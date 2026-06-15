package requests

// PresignRequest is the request body for generating a presigned S3 upload URL.
type PresignRequest struct {
	FileName      string `json:"fileName" binding:"required"`
	FileType      string `json:"fileType" binding:"required"`
	ContentLength int64  `json:"contentLength" binding:"required,gt=0"`
	Folder        string `json:"folder"`
	ExpiresIn     int64  `json:"expiresIn"`
}
