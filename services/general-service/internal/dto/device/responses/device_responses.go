package responses

// DeviceTokenResponse confirms a registered FCM device token (token value is not echoed back).
type DeviceTokenResponse struct {
	Platform string `json:"platform"`
	DeviceId string `json:"device_id,omitempty"`
}
