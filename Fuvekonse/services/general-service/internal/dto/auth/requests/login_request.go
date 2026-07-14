package requests

// LoginRequest represents the login request payload
type LoginRequest struct {
	Email      string `json:"email" binding:"required,email" example:"user@example.com"`
	Password   string `json:"password" binding:"required,min=6" example:"password123"`
	DeviceId   string `json:"device_id"`
	DeviceName string `json:"device_name"`
	Platform   string `json:"platform"`
	UserAgent  string `json:"-"`
	IPAddress  string `json:"-"`
}
