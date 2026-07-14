package config

import (
	"context"
	role "general-service/internal/common/constants"
	"general-service/internal/dto/common"
	"general-service/internal/handlers"
	"general-service/internal/middlewares"
	"general-service/internal/repositories"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// CheckHealth godoc
//
//	@Summary		Check service health
//	@Description	Returns pong and service status
//	@Tags			health
//	@Produce		json
//	@Success		200	{object}	common.HealthResponse
//	@Router			/ping [get]
func CheckHealth(c *gin.Context) {
	healthData := common.HealthResponse{
		Message: "pong",
		Status:  "healthy",
	}
	c.JSON(200, common.SuccessResponse(&healthData, "Service is healthy", 200))
}

func SetupAuthRoutes(router *gin.RouterGroup, h *handlers.Handlers, repos *repositories.Repositories) {
	jwtAuth := middlewares.JWTAuthMiddleware(repos.UserSession)
	auth := router.Group("/auth")
	{
		auth.POST("/register", h.Auth.Register)
		auth.POST("/login", h.Auth.Login)
		auth.POST("/google", h.Auth.GoogleLogin)
		auth.POST("/logout", jwtAuth, h.Auth.Logout)

		auth.GET("/sessions", jwtAuth, h.Auth.ListSessions)
		auth.DELETE("/sessions/:id", jwtAuth, h.Auth.RevokeSession)

		//add jwt auth
		auth.POST("/reset-password", jwtAuth, h.Auth.ResetPassword)
		auth.POST("/verify-otp", h.Auth.VerifyOtp)
		auth.POST("/resend-otp", h.Auth.ResendOtp)

		auth.POST("/forgot-password", h.Auth.ForgotPassword)
		auth.POST("/reset-password/confirm", h.Auth.ResetPasswordConfirm)
	}
}

func SetupAPIRoutes(router gin.IRouter, h *handlers.Handlers, db *gorm.DB, repos *repositories.Repositories, redisSetFunc func(ctx context.Context, key string, value interface{}, expiration time.Duration) error) {
	// Internal job endpoint (called by SQS worker) - no /v1 prefix for clarity

	internal := router.Group("/internal", middlewares.InternalAPIKeyMiddleware())
	{
		internal.POST("/jobs/ticket", h.Ticket.ProcessTicketJob)
	}

	// Root endpoint
	router.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"service": "General Service API",
			"version": "1.0",
			"status":  "running",
		})
	})

	router.GET("/health/db", func(c *gin.Context) {
		sqlDB, err := db.DB()
		if err != nil {
			c.JSON(500, gin.H{"error": "Database connection error"})
			return
		}
		if err := sqlDB.Ping(); err != nil {
			c.JSON(500, gin.H{"error": "Database ping failed"})
			return
		}
		c.JSON(200, gin.H{"status": "database healthy"})
	})

	// Redis health: call this HTTP endpoint (e.g. GET /health/redis). Do NOT point HTTP
	// probes at the Redis port (6379)—Redis speaks RESP, not HTTP. Sending HTTP to Redis
	// triggers "Possible SECURITY ATTACK" and aborts the connection.
	router.GET("/health/redis", func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()

		if err := redisSetFunc(ctx, "health_check", "ok", time.Minute); err != nil {
			c.JSON(500, gin.H{"error": "Redis connection failed"})
			return
		}
		c.JSON(200, gin.H{"status": "redis healthy"})
	})

	router.GET("/health/s3", h.Health.CheckS3)
	router.GET("/health/sqs", h.Health.CheckSQS)

	v1 := router.Group("/v1")
	{
		v1.GET("/ping", CheckHealth)
		SetupAuthRoutes(v1, h, repos)

		v1.GET("/event/settings", h.Event.GetEventSettings)

		// Public ticket routes (optional JWT so admins can get normalized tier payloads, e.g. is_active)
		tickets := v1.Group("/tickets")
		tickets.Use(middlewares.OptionalJWTAuthMiddleware(repos.UserSession))
		{
			tickets.GET("/tiers", h.Ticket.GetTiers)
			tickets.GET("/tiers/:id", h.Ticket.GetTierByID)
		}

		// Public S3 image proxy (streams object bytes from S3)
		v1.GET("/s3/image", h.S3.GetImage)

		// Public schedule routes (view-only)
		schedules := v1.Group("/schedules")
		{
			schedules.GET("", h.Schedule.ListSchedules)
			schedules.GET("/:id", h.Schedule.GetScheduleByID)
		}

		// Protected routes - require JWT authentication; verified users may call all, unverified only profile/verify whitelist
		protected := v1.Group("")
		protected.Use(middlewares.JWTAuthMiddleware(repos.UserSession))
		protected.Use(middlewares.RequireVerifiedOrWhitelist(repos.User))
		{
			// User routes
			users := protected.Group("/users")
			{
				users.GET("/me", h.User.GetMe)
				users.PUT("/me", h.User.UpdateProfile)
				users.PATCH("/me/avatar", h.User.UpdateAvatar)
				users.GET("/me/permissions", h.RBAC.GetMyPermissions)
			}

			// Dealer routes
			dealer := protected.Group("/dealer")
			{
				dealer.GET("/me", h.Dealer.GetMyDealer)
				dealer.POST("/register", h.Dealer.RegisterDealer)
				dealer.PATCH("/:id", h.Dealer.EditDealer)
				dealer.POST("/join", h.Dealer.JoinDealerBooth)
				dealer.DELETE("/leave", h.Dealer.LeaveDealerBooth)
				dealer.DELETE("/staff/remove", h.Dealer.RemoveStaffFromBooth)
			}

			// Protected ticket routes (require auth)
			protectedTickets := protected.Group("/tickets")
			{
				protectedTickets.GET("/me", h.Ticket.GetMyTicket)
				protectedTickets.POST("/purchase", h.Ticket.PurchaseTicket)
				protectedTickets.PATCH("/me/confirm", h.Ticket.ConfirmPayment)
				protectedTickets.DELETE("/me/cancel", h.Ticket.CancelTicket)
				protectedTickets.PATCH("/me/badge", h.Ticket.UpdateBadgeDetails)
				protectedTickets.PATCH("/me/tshirt-size", h.Ticket.UpdateTshirtSize)
				protectedTickets.PATCH("/me/upgrade", h.Ticket.UpgradeTicket)
			}

			// Protected conbook routes (require auth)
			protectedConbooks := protected.Group("/conbooks")
			{
				protectedConbooks.POST("/upload", h.Conbook.UploadConbook)
				protectedConbooks.GET("", h.Conbook.GetMyConbooks)
				protectedConbooks.GET("/:id", h.Conbook.GetConbookByID)
				protectedConbooks.PUT("/:id", h.Conbook.EditConbook)
				protectedConbooks.DELETE("/:id", h.Conbook.DeleteConbook)
			}

			protectedPanels := protected.Group("/panels")
			{
				protectedPanels.POST("", h.Panel.CreatePanel)
				protectedPanels.GET("", h.Panel.GetMyPanels)
				protectedPanels.GET("/:id", h.Panel.GetPanelByID)
				protectedPanels.PUT("/:id", h.Panel.EditPanel)
				protectedPanels.DELETE("/:id", h.Panel.DeletePanel)
			}

			protectedTalents := protected.Group("/talents")
			{
				protectedTalents.POST("", h.Talent.CreateTalent)
				protectedTalents.GET("", h.Talent.GetMyTalents)
				protectedTalents.GET("/:id", h.Talent.GetTalentByID)
				protectedTalents.PUT("/:id", h.Talent.EditTalent)
				protectedTalents.DELETE("/:id", h.Talent.DeleteTalent)
			}

			protectedNotifications := protected.Group("/notifications")
			{
				protectedNotifications.POST("", h.Notification.CreateNotification)
				protectedNotifications.GET("/unread-count", h.Notification.GetUnreadNotificationCount)
				protectedNotifications.PUT("/read-all", h.Notification.MarkAllNotificationsRead)
				protectedNotifications.GET("", h.Notification.ListMyNotifications)
				protectedNotifications.GET("/:id", h.Notification.GetNotificationByID)
				protectedNotifications.PUT("/:id", h.Notification.UpdateNotification)
				protectedNotifications.DELETE("/:id", h.Notification.DeleteNotification)
			}

			protectedDevices := protected.Group("/devices")
			{
				protectedDevices.POST("/fcm-token", h.DeviceToken.RegisterFCMToken)
				protectedDevices.DELETE("/fcm-token", h.DeviceToken.UnregisterFCMToken)
			}

			protectedS3 := protected.Group("/s3")
			{
				protectedS3.POST("/presign", h.S3.PresignUpload)
			}

			protectedLostFound := protected.Group("/lost-found")
			{
				protectedLostFound.GET("", h.LostFound.ListLostFoundForTicketHolder)
				protectedLostFound.GET("/:id", h.LostFound.GetLostFoundByIDForTicketHolder)
				protectedLostFound.POST("/:id/claim", h.LostFound.ClaimLostFound)
			}
		}

		// Admin routes - require JWT; role or permission enforced per subgroup
		admin := v1.Group("/admin")
		admin.Use(middlewares.JWTAuthMiddleware(repos.UserSession))
		{
			adminRBAC := admin.Group("/rbac")
			adminRBAC.Use(middlewares.RequireRole(role.RoleAdmin))
			{
				adminRBAC.GET("", h.RBAC.GetConfig)
				adminRBAC.PUT("/roles/:role/permissions", h.RBAC.UpdateRolePermissions)
			}

			// Admin-only user management
			adminUsers := admin.Group("/users")
			adminUsers.Use(middlewares.RequirePermission(repos.RBAC, role.PermManageUsers))
			{
				adminUsers.GET("", h.User.GetAllUsers)
				adminUsers.GET("/statistics/count-by-country", h.User.GetUserCountByCountry)
				adminUsers.GET("/statistics/count-by-age-range", h.User.GetUserCountByAgeRange)
				adminUsers.GET("/:id", h.User.GetUserByIDForAdmin)
				adminUsers.PUT("/:id", h.User.UpdateUserByAdmin)
				adminUsers.DELETE("/:id", h.User.DeleteUser)
				adminUsers.PATCH("/:id/verify", h.User.VerifyUser)
				adminUsers.GET("/blacklisted", h.Ticket.GetBlacklistedUsers)
				adminUsers.PATCH("/:id/blacklist", h.Ticket.BlacklistUser)
				adminUsers.PATCH("/:id/unblacklist", h.Ticket.UnblacklistUser)
			}

			// Admin-only convention / event controls (ticket sales window, etc.)
			adminEvent := admin.Group("/event")
			adminEvent.Use(middlewares.RequirePermission(repos.RBAC, role.PermManageTickets))
			{
				adminEvent.GET("/settings", h.Event.GetEventSettingsForAdmin)
				adminEvent.PATCH("/settings", h.Event.UpdateEventSettingsForAdmin)
				adminEvent.POST("/ticket-sales/open", h.Event.OpenTicketSalesForAdmin)
				adminEvent.POST("/ticket-sales/close", h.Event.CloseTicketSalesForAdmin)
				adminEvent.POST("/panel-registration/open", h.Event.OpenPanelRegistrationForAdmin)
				adminEvent.POST("/panel-registration/close", h.Event.ClosePanelRegistrationForAdmin)
				adminEvent.POST("/talent-registration/open", h.Event.OpenTalentRegistrationForAdmin)
				adminEvent.POST("/talent-registration/close", h.Event.CloseTalentRegistrationForAdmin)
				adminEvent.POST("/dealer-registration/open", h.Event.OpenDealerRegistrationForAdmin)
				adminEvent.POST("/dealer-registration/close", h.Event.CloseDealerRegistrationForAdmin)
			}

			// Admin-only ticket management (literal paths first so /statistics, /tiers etc. don’t match as :id)
			adminTickets := admin.Group("/tickets")
			adminTickets.Use(middlewares.RequirePermission(repos.RBAC, role.PermManageTickets))
			{
				adminTickets.GET("", h.Ticket.GetTicketsForAdmin)
				adminTickets.POST("", h.Ticket.CreateTicketForAdmin)
				adminTickets.GET("/statistics/timeline", h.Ticket.GetTicketSalesTimeline)
				adminTickets.GET("/statistics/revenue", h.Ticket.GetTicketRevenue)
				adminTickets.GET("/statistics", h.Ticket.GetTicketStatistics)
				adminTickets.GET("/namecards/download", h.Ticket.DownloadAllNamecards)
				adminTickets.GET("/tiers", h.Ticket.GetAllTiersForAdmin)
				adminTickets.POST("/tiers", h.Ticket.CreateTierForAdmin)
				adminTickets.PATCH("/tiers/:id", h.Ticket.UpdateTierForAdmin)
				adminTickets.DELETE("/tiers/:id", h.Ticket.DeleteTierForAdmin)
				adminTickets.PATCH("/tiers/:id/activate", h.Ticket.ActivateTierForAdmin)
				adminTickets.PATCH("/tiers/:id/deactivate", h.Ticket.DeactivateTierForAdmin)
				adminTickets.PATCH("/tiers/:id/visibility", h.Ticket.SetTierVisibleForAdmin)
				adminTickets.PATCH("/:id/deny", h.Ticket.DenyTicket)
				adminTickets.PATCH("/:id", h.Ticket.UpdateTicketForAdmin)
				adminTickets.DELETE("/:id", h.Ticket.DeleteTicketForAdmin)
			}

			// Ticket scan / check-in: requires scan_tickets permission
			adminTicketsStaffOK := admin.Group("/tickets")
			adminTicketsStaffOK.Use(middlewares.RequirePermission(repos.RBAC, role.PermScanTickets))
			{
				adminTicketsStaffOK.GET("/:id", h.Ticket.GetTicketByID)
				adminTicketsStaffOK.PATCH("/:id/approve", h.Ticket.ApproveTicket)
				adminTicketsStaffOK.POST("/:id/resend-qr", h.Ticket.ResendTicketQREmail)
				adminTicketsStaffOK.PATCH("/:id/check-in", h.Ticket.ConfirmCheckIn)
			}

			// Dealer verification workflow
			adminDealers := admin.Group("/dealers")
			adminDealers.Use(middlewares.RequirePermission(repos.RBAC, role.PermApproveProfiles))
			{
				adminDealers.GET("", h.Dealer.GetDealersForAdmin)
				adminDealers.GET("/:id", h.Dealer.GetDealerByIDForAdmin)
				adminDealers.PATCH("/:id/verify", h.Dealer.VerifyDealer)
				adminDealers.PATCH("/:id/deny", h.Dealer.DenyDealer)
			}

			adminNotifications := admin.Group("/notifications")
			adminNotifications.Use(middlewares.RequirePermission(repos.RBAC, role.PermSendNotifications))
			{
				adminNotifications.GET("", h.Notification.AdminListNotifications)
				adminNotifications.POST("/broadcast", h.Notification.AdminBroadcastNotification)
				adminNotifications.POST("", h.Notification.AdminCreateNotification)
			}

			// Conbook / panel / talent profile approval
			adminConbooks := admin.Group("/conbooks")
			adminConbooks.Use(middlewares.RequirePermission(repos.RBAC, role.PermApproveProfiles))
			{
				adminConbooks.GET("/pending", h.Conbook.GetPendingConbooks)
				adminConbooks.GET("/approved", h.Conbook.GetApprovedConbooks)
				adminConbooks.GET("/require-changes", h.Conbook.GetRequireChangesConbooks)
				adminConbooks.GET("/denied", h.Conbook.GetDeniedConbooks)
				adminConbooks.PATCH("/:id/approve", h.Conbook.ApproveConbook)
				adminConbooks.PATCH("/:id/require-changes", h.Conbook.RequestConbookChanges)
				adminConbooks.PATCH("/:id/deny", h.Conbook.DenyConbook)
				adminConbooks.PATCH("/:id/pending", h.Conbook.MarkConbookPending)
			}

			adminPanels := admin.Group("/panels")
			adminPanels.Use(middlewares.RequirePermission(repos.RBAC, role.PermApproveProfiles))
			{
				adminPanels.GET("/pending", h.Panel.GetPendingPanels)
				adminPanels.GET("/approved", h.Panel.GetApprovedPanels)
				adminPanels.GET("/require-changes", h.Panel.GetRequireChangesPanels)
				adminPanels.GET("/denied", h.Panel.GetDeniedPanels)
				adminPanels.PATCH("/:id/schedule", h.Panel.AssignPanelSchedule)
				adminPanels.PATCH("/:id/approve", h.Panel.ApprovePanel)
				adminPanels.PATCH("/:id/require-changes", h.Panel.RequestPanelChanges)
				adminPanels.PATCH("/:id/deny", h.Panel.DenyPanel)
				adminPanels.PATCH("/:id/pending", h.Panel.MarkPanelPending)
			}

			adminSchedules := admin.Group("/admin-schedules")
			adminSchedules.Use(middlewares.RequirePermission(repos.RBAC, role.PermApproveProfiles))
			{
				adminSchedules.POST("", h.Schedule.CreateSchedule)
				adminSchedules.PUT(":id", h.Schedule.UpdateSchedule)
				adminSchedules.DELETE(":id", h.Schedule.DeleteSchedule)
				adminSchedules.POST("/:id/timeline", h.Schedule.CreateTimelineItem)
				adminSchedules.PUT("/:id/timeline/:tid", h.Schedule.UpdateTimelineItem)
				adminSchedules.DELETE("/:id/timeline/:tid", h.Schedule.DeleteTimelineItem)
			}

			// Global venue catalog (separate from schedule timeline)
			adminVenues := admin.Group("/venues")
			adminVenues.Use(middlewares.RequirePermission(repos.RBAC, role.PermApproveProfiles))
			{
				adminVenues.POST("", h.Venue.CreateVenue)
				adminVenues.GET("", h.Venue.ListVenues)
				adminVenues.GET(":vid", h.Venue.GetVenueByID)
				adminVenues.GET(":vid/locations", h.Venue.ListLocationsByVenue)
				adminVenues.POST(":vid/locations", h.Venue.CreateLocation)
			}

			// Alias: /admin/schedules
			adminSchedulesAlias := admin.Group("/schedules")
			adminSchedulesAlias.Use(middlewares.RequirePermission(repos.RBAC, role.PermApproveProfiles))
			{
				adminSchedulesAlias.POST("", h.Schedule.CreateSchedule)
				adminSchedulesAlias.PUT(":id", h.Schedule.UpdateSchedule)
				adminSchedulesAlias.DELETE(":id", h.Schedule.DeleteSchedule)
				adminSchedulesAlias.POST("/:id/timeline", h.Schedule.CreateTimelineItem)
				adminSchedulesAlias.PUT("/:id/timeline/:tid", h.Schedule.UpdateTimelineItem)
				adminSchedulesAlias.DELETE("/:id/timeline/:tid", h.Schedule.DeleteTimelineItem)
			}

			adminTalents := admin.Group("/talents")
			adminTalents.Use(middlewares.RequirePermission(repos.RBAC, role.PermApproveProfiles))
			{
				adminTalents.GET("/pending", h.Talent.GetPendingTalents)
				adminTalents.GET("/approved", h.Talent.GetApprovedTalents)
				adminTalents.GET("/require-changes", h.Talent.GetRequireChangesTalents)
				adminTalents.GET("/denied", h.Talent.GetDeniedTalents)
				adminTalents.PATCH("/:id/schedule", h.Talent.AssignTalentSchedule)
				adminTalents.PATCH("/:id/approve", h.Talent.ApproveTalent)
				adminTalents.PATCH("/:id/require-changes", h.Talent.RequestTalentChanges)
				adminTalents.PATCH("/:id/deny", h.Talent.DenyTalent)
				adminTalents.PATCH("/:id/pending", h.Talent.MarkTalentPending)
			}

			adminLostFound := admin.Group("/lost-found")
			adminLostFound.Use(middlewares.RequirePermission(repos.RBAC, role.PermApproveProfiles))
			{
				adminLostFound.POST("", h.LostFound.CreateLostFound)
				adminLostFound.GET("", h.LostFound.ListLostFound)
				adminLostFound.GET("/:id", h.LostFound.GetLostFoundByID)
				adminLostFound.PUT("/:id", h.LostFound.UpdateLostFound)
				adminLostFound.PATCH("/:id/status", h.LostFound.UpdateLostFoundStatus)
				adminLostFound.POST("/:id/return", h.LostFound.ConfirmLostFoundReturn)
				adminLostFound.DELETE("/:id", h.LostFound.DeleteLostFound)
			}

			// Admin-only dashboard analytics (single consolidated query)
			adminAnalytics := admin.Group("/analytics")
			adminAnalytics.Use(middlewares.RequirePermission(repos.RBAC, role.PermViewDashboard))
			{
				adminAnalytics.GET("/dashboard", h.Analytics.GetDashboard)
			}

			adminHealth := admin.Group("/health")
			adminHealth.Use(middlewares.RequireRole(role.RoleStaff, role.RoleAdmin))
			{
				adminHealth.GET("", h.Health.GetSystemHealth)
			}
		}

		// Dev-only: send a test email (OTP / dealer approved / ticket+QR) without going through auth flows
		if GetEnvOr("ENV", "development") != "production" {
			dev := v1.Group("/dev")
			{
				dev.POST("/mail/send", h.DevMail.SendTestMail)
			}
		}
	}
}
