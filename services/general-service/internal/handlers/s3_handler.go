package handlers

import (
	"errors"
	"general-service/internal/common/utils"
	"general-service/internal/dto/s3/requests"
	"general-service/internal/dto/s3/responses"
	"general-service/internal/services"
	"io"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type S3Handler struct {
	services *services.Services
}

func NewS3Handler(services *services.Services) *S3Handler {
	return &S3Handler{services: services}
}

// PresignUpload godoc
// @Summary Generate a presigned S3 upload URL
// @Description Returns a presigned PUT URL for direct client upload to S3
// @Tags s3
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body requests.PresignRequest true "Presign request"
// @Success 200 "Presigned URL generated successfully"
// @Failure 400 "Invalid request"
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal server error"
// @Router /s3/presign [post]
func (h *S3Handler) PresignUpload(c *gin.Context) {
	if h.services.S3 == nil {
		utils.RespondInternalServerError(c, "S3 is not configured")
		return
	}

	var req requests.PresignRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	result, err := h.services.S3.PresignUpload(c.Request.Context(), services.PresignUploadInput{
		FileName:      req.FileName,
		FileType:      req.FileType,
		ContentLength: req.ContentLength,
		Folder:        req.Folder,
		ExpiresIn:     req.ExpiresIn,
	})
	if err != nil {
		switch {
		case errors.Is(err, services.ErrInvalidUploadSize):
			utils.RespondBadRequest(c, "File size exceeds maximum allowed (50MB)")
		case errors.Is(err, services.ErrInvalidFileType):
			utils.RespondBadRequest(c, "File type not allowed. Allowed: JPEG, PNG, GIF, WebP, SVG, AVIF (and for artbooks: PDF, DOC, DOCX).")
		case errors.Is(err, services.ErrInvalidFolder):
			utils.RespondBadRequest(c, "Invalid folder parameter")
		default:
			utils.RespondInternalServerError(c, "Failed to generate presigned URL")
		}
		return
	}

	response := responses.PresignResponse{
		PresignedURL: result.PresignedURL,
		FileKey:      result.FileKey,
		FileURL:      result.FileURL,
	}
	utils.RespondSuccess(c, &response, "Presigned URL generated successfully")
}

// GetImage godoc
// @Summary Stream or redirect to an S3 object
// @Description Streams object bytes for small files (canvas/fetch). Objects larger than 5 MB redirect to a presigned S3 URL so Lambda response limits are not exceeded.
// @Tags s3
// @Param key query string true "S3 object key"
// @Success 200 "Image bytes"
// @Success 307 "Redirect to presigned S3 URL for large objects"
// @Failure 400 "Invalid request"
// @Failure 404 "Object not found"
// @Failure 500 "Internal server error"
// @Router /s3/image [get]
func (h *S3Handler) GetImage(c *gin.Context) {
	if h.services.S3 == nil {
		utils.RespondInternalServerError(c, "S3 is not configured")
		return
	}

	rawKey := c.Query("key")
	if rawKey == "" {
		utils.RespondBadRequest(c, "Missing key parameter")
		return
	}

	decodedKey, err := services.DecodeObjectKey(rawKey)
	if err != nil {
		utils.RespondBadRequest(c, "Invalid key format")
		return
	}

	ctx := c.Request.Context()

	meta, err := h.services.S3.HeadObject(ctx, decodedKey)
	if err != nil {
		if errors.Is(err, services.ErrObjectNotFound) {
			utils.RespondNotFound(c, "Object not found")
			return
		}
		log.Printf("S3 GetImage head failed for key %q: %v", decodedKey, err)
		utils.RespondInternalServerError(c, "Failed to fetch object")
		return
	}

	if meta.ContentLength > services.MaxStreamBytes {
		presignedURL, err := h.services.S3.PresignGetObject(ctx, decodedKey, 0)
		if err != nil {
			if errors.Is(err, services.ErrObjectNotFound) {
				utils.RespondNotFound(c, "Object not found")
				return
			}
			log.Printf("S3 GetImage presign failed for key %q: %v", decodedKey, err)
			utils.RespondInternalServerError(c, "Failed to fetch object")
			return
		}
		c.Redirect(http.StatusTemporaryRedirect, presignedURL)
		return
	}

	obj, err := h.services.S3.GetObject(ctx, decodedKey)
	if err != nil {
		if errors.Is(err, services.ErrObjectNotFound) {
			utils.RespondNotFound(c, "Object not found")
			return
		}
		log.Printf("S3 GetImage failed for key %q: %v", decodedKey, err)
		utils.RespondInternalServerError(c, "Failed to fetch object")
		return
	}
	defer obj.Body.Close()

	c.Header("Content-Type", obj.ContentType)
	c.Header("Cache-Control", "private, max-age=300")
	if obj.ContentLength > 0 {
		c.Header("Content-Length", strconv.FormatInt(obj.ContentLength, 10))
	}
	c.Status(http.StatusOK)
	if _, err := io.Copy(c.Writer, obj.Body); err != nil {
		log.Printf("S3 GetImage stream failed for key %q: %v", decodedKey, err)
	}
}
