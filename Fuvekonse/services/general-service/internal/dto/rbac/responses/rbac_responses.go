package responses

type PermissionResponse struct {
	Code    string `json:"code"`
	LabelEn string `json:"label_en"`
	LabelVi string `json:"label_vi"`
}

type RolePermissionsResponse struct {
	Role        string   `json:"role"`
	LabelEn     string   `json:"label_en"`
	LabelVi     string   `json:"label_vi"`
	Permissions []string `json:"permissions"`
}

type RBACConfigResponse struct {
	Roles       []RolePermissionsResponse `json:"roles"`
	Permissions []PermissionResponse      `json:"permissions"`
}
