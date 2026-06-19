package main

import (
	"encoding/json"
	"errors"
	"general-service/internal/models"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
)

// Mirrors lib/features/ticket/data/mock/mock_ticket_data.dart and workshop demo QR.
type seedTierSpec struct {
	TierCode    string
	TicketName  string
	Description string
	Benefits    []string
	Price       float64
	PriceUsd    float64
	Stock       int
}

type seedTicketSpec struct {
	UserEmail     string
	TierCode      string
	ReferenceCode string
	TicketNumber  int
	Status        models.TicketStatus
	ConBadgeName  string
}

var seedTiers = []seedTierSpec{
	{
		TierCode:    "T1",
		TicketName:  "Standard",
		Description: "Vé tiêu chuẩn — tham gia sự kiện, badge và quà cơ bản.",
		Benefits: []string{
			"1-Day Event Pass",
			"Standard Name Badge",
			"Basic Gift Set",
		},
		Price:    150000,
		PriceUsd: 6,
		Stock:    200,
	},
	{
		TierCode:    "T2",
		TicketName:  "VIP",
		Description: "Check-in ưu tiên, badge tùy chỉnh và bộ quà nâng cao.",
		Benefits: []string{
			"Lối đi ưu tiên riêng biệt (Fast Track)",
			"Khu vực Lounge VIP với thức uống miễn phí",
			"Túi quà tặng (Gift bag) phiên bản giới hạn",
		},
		Price:    750000,
		PriceUsd: 30,
		Stock:    100,
	},
	{
		TierCode:    "T3",
		TicketName:  "Super Sponsor",
		Description: "Trải nghiệm thượng lưu trọn vẹn",
		Benefits: []string{
			"Ký tặng Seiyuu riêng (Slot Private)",
			"Đặc quyền Tea-break tại VIP Lounge",
			"Set quà tặng Ultra-rare phiên bản giới hạn",
		},
		Price:    1500000,
		PriceUsd: 60,
		Stock:    50,
	},
	{
		TierCode:    "WS",
		TicketName:  "Workshop",
		Description: "Vé workshop — tham gia trực tiếp, tài liệu và vật liệu.",
		Benefits: []string{
			"Tham gia workshop trực tiếp",
			"Tài liệu và vật liệu được cung cấp",
		},
		Price:    200000,
		PriceUsd: 8,
		Stock:    80,
	},
}

var seedTickets = []seedTicketSpec{
	{
		UserEmail:     "user@fuve.com",
		TierCode:      "WS",
		ReferenceCode: "FVK-WS-DEMO",
		TicketNumber:  1,
		Status:        models.TicketStatusApproved,
		ConBadgeName:  "User Test",
	},
	{
		UserEmail:     "user@example.com",
		TierCode:      "T1",
		ReferenceCode: "FVK-DEMO-001",
		TicketNumber:  1,
		Status:        models.TicketStatusApproved,
		ConBadgeName:  "Test User",
	},
	{
		UserEmail:     "dealer@fuve.com",
		TierCode:      "T2",
		ReferenceCode: "FVK-DEMO-002",
		TicketNumber:  1,
		Status:        models.TicketStatusApproved,
		ConBadgeName:  "Dealer Test",
	},
}

func seedTicketCatalog(db *gorm.DB) error {
	log.Println("\n🎫 Seeding ticket tiers...")
	log.Println("========================")

	for i, spec := range seedTiers {
		log.Printf("[%d/%d] Tier %s (%s)", i+1, len(seedTiers), spec.TierCode, spec.TicketName)
		if err := upsertTicketTier(db, spec); err != nil {
			return err
		}
	}

	log.Println("========================")
	log.Println("🎫 Seeding demo tickets...")

	var admin models.User
	if err := db.Where("email = ? AND is_deleted = ?", "admin@fuve.com", false).First(&admin).Error; err != nil {
		return err
	}

	for i, spec := range seedTickets {
		log.Printf("[%d/%d] %s → %s", i+1, len(seedTickets), spec.UserEmail, spec.ReferenceCode)
		if err := upsertDemoTicket(db, admin.Id, spec); err != nil {
			return err
		}
	}

	log.Println("========================")
	log.Println("Demo ticket reference codes:")
	for _, spec := range seedTickets {
		log.Printf("  %s (%s)", spec.ReferenceCode, spec.UserEmail)
	}

	return nil
}

func upsertTicketTier(db *gorm.DB, spec seedTierSpec) error {
	benefitsJSON, err := json.Marshal(spec.Benefits)
	if err != nil {
		return err
	}

	now := time.Now()
	var existing models.TicketTier
	result := db.Where("tier_code = ? AND is_deleted = ?", spec.TierCode, false).First(&existing)

	updates := map[string]interface{}{
		"ticket_name":  spec.TicketName,
		"description":  spec.Description,
		"benefits":     string(benefitsJSON),
		"price":        decimal.NewFromFloat(spec.Price),
		"price_usd":    decimal.NewFromFloat(spec.PriceUsd),
		"stock":        spec.Stock,
		"is_active":    true,
		"is_visible":   true,
		"is_deleted":   false,
		"modified_at":  now,
	}

	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		tier := models.TicketTier{
			Id:          uuid.New(),
			TierCode:    spec.TierCode,
			TicketName:  spec.TicketName,
			Description: spec.Description,
			Benefits:    string(benefitsJSON),
			Price:       decimal.NewFromFloat(spec.Price),
			PriceUsd:    decimal.NewFromFloat(spec.PriceUsd),
			Stock:       spec.Stock,
			IsActive:    true,
			IsVisible:   true,
			CreatedAt:   now,
			ModifiedAt:  now,
			IsDeleted:   false,
		}
		if err := db.Create(&tier).Error; err != nil {
			return err
		}
		log.Printf("  ✅ Created tier %s", spec.TierCode)
		return nil
	}
	if result.Error != nil {
		return result.Error
	}

	if err := db.Model(&existing).Updates(updates).Error; err != nil {
		return err
	}
	log.Printf("  ⚠️  Updated tier %s", spec.TierCode)
	return nil
}

func upsertDemoTicket(db *gorm.DB, adminID uuid.UUID, spec seedTicketSpec) error {
	var user models.User
	if err := db.Where("email = ? AND is_deleted = ?", spec.UserEmail, false).First(&user).Error; err != nil {
		return err
	}

	var tier models.TicketTier
	if err := db.Where("tier_code = ? AND is_deleted = ?", spec.TierCode, false).First(&tier).Error; err != nil {
		return err
	}

	now := time.Now()
	approvedAt := now

	// Keep one demo ticket per user — remove other non-denied tickets for a clean dev state.
	if err := db.Model(&models.UserTicket{}).
		Where(
			"user_id = ? AND is_deleted = ? AND status != ? AND reference_code != ?",
			user.Id, false, models.TicketStatusDenied, spec.ReferenceCode,
		).
		Updates(map[string]interface{}{
			"is_deleted": true,
			"deleted_at": now,
			"modified_at": now,
		}).Error; err != nil {
		return err
	}

	var existing models.UserTicket
	result := db.Where("reference_code = ? AND is_deleted = ?", spec.ReferenceCode, false).First(&existing)

	updates := map[string]interface{}{
		"user_id":        user.Id,
		"ticket_id":      tier.Id,
		"ticket_number":  spec.TicketNumber,
		"status":         spec.Status,
		"con_badge_name": spec.ConBadgeName,
		"approved_at":    &approvedAt,
		"approved_by":    &adminID,
		"is_checked_in":  false,
		"is_deleted":     false,
		"modified_at":    now,
	}

	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		ticket := models.UserTicket{
			Id:            uuid.New(),
			UserId:        user.Id,
			TicketId:      tier.Id,
			TicketNumber:  spec.TicketNumber,
			ReferenceCode: spec.ReferenceCode,
			Status:        spec.Status,
			ConBadgeName:  spec.ConBadgeName,
			ApprovedAt:    &approvedAt,
			ApprovedBy:    &adminID,
			IsCheckedIn:   false,
			CreatedAt:     now,
			ModifiedAt:    now,
			IsDeleted:     false,
		}
		if err := db.Create(&ticket).Error; err != nil {
			return err
		}
		log.Printf("  ✅ Created ticket %s", spec.ReferenceCode)
		return nil
	}
	if result.Error != nil {
		return result.Error
	}

	if err := db.Model(&existing).Updates(updates).Error; err != nil {
		return err
	}
	log.Printf("  ⚠️  Updated ticket %s", spec.ReferenceCode)
	return nil
}
