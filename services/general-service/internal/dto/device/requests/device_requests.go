package requests

// RegisterFCMTokenRequest registers or updates an FCM device token for the authenticated user.
type RegisterFCMTokenRequest struct {
	Token    string `json:"token" binding:"required,min=1,max=512"`
	Platform string `json:"platform" binding:"required"`
	DeviceId string `json:"device_id" binding:"omitempty,max=255"`
}

// UnregisterFCMTokenRequest removes an FCM device token (e.g. on logout).
type UnregisterFCMTokenRequest struct {
	Token string `json:"token" binding:"required,min=1,max=512"`
}
