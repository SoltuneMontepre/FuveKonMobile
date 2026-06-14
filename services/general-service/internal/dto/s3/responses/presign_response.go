package responses

// PresignResponse is returned after generating a presigned S3 upload URL.
type PresignResponse struct {
	PresignedURL string `json:"presignedUrl"`
	FileKey      string `json:"fileKey"`
	FileURL      string `json:"fileUrl"`
}
