package services

import (
	"context"
	"errors"
	"fmt"
	"general-service/internal/common/constants"
	"general-service/internal/dto/lostfound/requests"
	"general-service/internal/dto/lostfound/responses"
	"general-service/internal/mappers"
	"general-service/internal/models"
	"general-service/internal/repositories"
	"log"
	"math"
	"strings"
	"time"

	"github.com/google/uuid"
)

func lostFoundDisplayCode(id uuid.UUID) string {
	s := strings.ReplaceAll(id.String(), "-", "")
	if len(s) >= 5 {
		return "FND-" + strings.ToUpper(s[len(s)-5:])
	}
	return "FND-" + strings.ToUpper(s)
}

var ErrLostFoundNotFound = repositories.ErrLostFoundNotFound

var (
	ErrLostFoundTicketRequired      = errors.New("user must have a ticket to view lost and found")
	ErrLostFoundTicketNotApproved   = errors.New("user ticket must be approved to view lost and found")
	ErrLostFoundAlreadyReturned     = errors.New("lost and found item has already been returned")
	ErrLostFoundInvalidReturn       = errors.New("return confirmation requires all verification checks")
	ErrLostFoundNotReturnable       = errors.New("only claimed found items with a pending claim can be returned")
	ErrLostFoundNoClaim               = errors.New("no pending claim found for this item")
	ErrLostFoundNotClaimable          = errors.New("only open found items can be claimed")
	ErrLostFoundAlreadyClaimed        = errors.New("this item already has a pending claim")
	ErrLostFoundUserAlreadyClaimed    = errors.New("you have already claimed this item")
)

type LostFoundService struct {
	repos  *repositories.Repositories
	notify *NotificationService
}

func NewLostFoundService(repos *repositories.Repositories, notify *NotificationService) *LostFoundService {
	return &LostFoundService{repos: repos, notify: notify}
}

func (s *LostFoundService) Create(ctx context.Context, userIDStr string, req *requests.CreateLostFoundRequest) (*responses.LostFoundResponse, error) {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}

	id := uuid.New()
	item := &models.LostFoundItem{
		Id:                id,
		DisplayCode:       lostFoundDisplayCode(id),
		ItemType:          models.LostFoundItemType(req.ItemType),
		Title:             strings.TrimSpace(req.Title),
		Description:       strings.TrimSpace(req.Description),
		Location:          strings.TrimSpace(req.Location),
		ImageUrl:          strings.TrimSpace(req.ImageUrl),
		ContactInfo:       strings.TrimSpace(req.ContactInfo),
		StaffNotes:        strings.TrimSpace(req.StaffNotes),
		Status:            models.LostFoundStatusOpen,
		SubmittedByUserId: userID,
	}

	created, err := s.repos.LostFound.Create(ctx, item)
	if err != nil {
		log.Printf("Error creating lost and found item: %v", err)
		return nil, err
	}

	resp := mappers.MapLostFoundToResponse(created, nil)
	return &resp, nil
}

func (s *LostFoundService) loadActiveClaim(ctx context.Context, itemID uuid.UUID) (*models.LostFoundClaim, error) {
	claim, err := s.repos.LostFoundClaim.GetPendingByItemID(ctx, itemID)
	if err != nil {
		if errors.Is(err, repositories.ErrLostFoundClaimNotFound) {
			return nil, nil
		}
		return nil, err
	}

	user, err := s.repos.User.FindByID(claim.ClaimedByUserId.String())
	if err != nil {
		log.Printf("Error loading claim user for lost and found: %v", err)
	} else if user != nil {
		claim.ClaimedBy = *user
	}

	return claim, nil
}

func (s *LostFoundService) GetByID(ctx context.Context, idStr string) (*responses.LostFoundResponse, error) {
	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid item id")
	}

	item, err := s.repos.LostFound.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	claim, err := s.loadActiveClaim(ctx, id)
	if err != nil {
		return nil, err
	}

	resp := mappers.MapLostFoundToResponse(item, claim)
	return &resp, nil
}

func (s *LostFoundService) List(ctx context.Context, q requests.ListLostFoundQuery) (*responses.LostFoundListResponse, error) {
	items, total, err := s.repos.LostFound.List(ctx, q)
	if err != nil {
		log.Printf("Error listing lost and found items: %v", err)
		return nil, err
	}

	page := q.Page
	if page < 1 {
		page = 1
	}
	pageSize := q.PageSize
	if pageSize < 1 {
		pageSize = 20
	}
	if pageSize > 100 {
		pageSize = 100
	}

	totalPages := int(math.Ceil(float64(total) / float64(pageSize)))
	if total == 0 {
		totalPages = 0
	}

	return &responses.LostFoundListResponse{
		Items:      mappers.MapLostFoundListToResponse(items),
		Total:      total,
		Page:       page,
		PageSize:   pageSize,
		TotalPages: totalPages,
	}, nil
}

func (s *LostFoundService) Update(ctx context.Context, idStr string, req *requests.UpdateLostFoundRequest) (*responses.LostFoundResponse, error) {
	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid item id")
	}

	existing, err := s.repos.LostFound.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	if req.ItemType != nil {
		existing.ItemType = models.LostFoundItemType(*req.ItemType)
	}
	if req.Title != nil {
		existing.Title = strings.TrimSpace(*req.Title)
	}
	if req.Description != nil {
		existing.Description = strings.TrimSpace(*req.Description)
	}
	if req.Location != nil {
		existing.Location = strings.TrimSpace(*req.Location)
	}
	if req.ImageUrl != nil {
		existing.ImageUrl = strings.TrimSpace(*req.ImageUrl)
	}
	if req.ContactInfo != nil {
		existing.ContactInfo = strings.TrimSpace(*req.ContactInfo)
	}
	if req.StaffNotes != nil {
		existing.StaffNotes = strings.TrimSpace(*req.StaffNotes)
	}

	updated, err := s.repos.LostFound.Update(ctx, existing)
	if err != nil {
		log.Printf("Error updating lost and found item: %v", err)
		return nil, err
	}

	claim, err := s.loadActiveClaim(ctx, id)
	if err != nil {
		return nil, err
	}

	resp := mappers.MapLostFoundToResponse(updated, claim)
	return &resp, nil
}

func (s *LostFoundService) UpdateStatus(ctx context.Context, idStr string, req *requests.UpdateLostFoundStatusRequest) (*responses.LostFoundResponse, error) {
	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid item id")
	}

	status := models.LostFoundItemStatus(req.Status)
	if err := s.repos.LostFound.SetStatus(ctx, id, status); err != nil {
		return nil, err
	}

	item, err := s.repos.LostFound.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	claim, err := s.loadActiveClaim(ctx, id)
	if err != nil {
		return nil, err
	}

	resp := mappers.MapLostFoundToResponse(item, claim)
	return &resp, nil
}

func (s *LostFoundService) Delete(ctx context.Context, idStr string) error {
	id, err := uuid.Parse(idStr)
	if err != nil {
		return errors.New("invalid item id")
	}

	return s.repos.LostFound.Delete(ctx, id)
}

func (s *LostFoundService) ClaimItem(ctx context.Context, userIDStr, idStr string, req *requests.ClaimLostFoundRequest) (*responses.LostFoundClaimResultResponse, error) {
	if err := s.ensureTicketHolder(ctx, userIDStr); err != nil {
		return nil, err
	}

	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}

	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid item id")
	}

	item, err := s.repos.LostFound.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	if item.ItemType != models.LostFoundTypeFound || item.Status != models.LostFoundStatusOpen {
		return nil, ErrLostFoundNotClaimable
	}

	if _, err := s.repos.LostFoundClaim.GetPendingByItemID(ctx, id); err == nil {
		return nil, ErrLostFoundAlreadyClaimed
	} else if !errors.Is(err, repositories.ErrLostFoundClaimNotFound) {
		return nil, err
	}

	if existingClaim, err := s.repos.LostFoundClaim.GetByItemAndUser(ctx, id, userID); err == nil {
		if existingClaim.Status == models.LostFoundClaimPending {
			return &responses.LostFoundClaimResultResponse{
				ItemId:  id,
				Status:  string(existingClaim.Status),
				Message: "You already have a pending claim for this item",
			}, nil
		}
		return nil, ErrLostFoundUserAlreadyClaimed
	} else if !errors.Is(err, repositories.ErrLostFoundClaimNotFound) {
		return nil, err
	}

	claim := &models.LostFoundClaim{
		ItemId:          id,
		ClaimedByUserId: userID,
		Message:         strings.TrimSpace(req.Message),
		Status:          models.LostFoundClaimPending,
	}

	if _, err := s.repos.LostFoundClaim.Create(ctx, claim); err != nil {
		log.Printf("Error creating lost and found claim: %v", err)
		return nil, err
	}

	if err := s.repos.LostFound.SetStatus(ctx, id, models.LostFoundStatusClaimed); err != nil {
		return nil, err
	}

	if s.notify != nil {
		label := strings.TrimSpace(item.Title)
		if label == "" {
			label = "vật phẩm"
		}
		s.notify.NotifyUser(
			ctx,
			item.SubmittedByUserId,
			"Có yêu cầu nhận đồ",
			fmt.Sprintf("Có người yêu cầu nhận %s bạn đã báo tìm thấy.", label),
			constants.NotificationKindLostFound,
		)
	}

	return &responses.LostFoundClaimResultResponse{
		ItemId:  id,
		Status:  string(models.LostFoundClaimPending),
		Message: "Claim submitted successfully",
	}, nil
}

func (s *LostFoundService) ConfirmReturn(ctx context.Context, staffIDStr, idStr string, req *requests.ConfirmLostFoundReturnRequest) (*responses.LostFoundResponse, error) {
	staffID, err := uuid.Parse(staffIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}

	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid item id")
	}

	if !req.VerifiedDescription || !req.VerifiedOwnership || !req.VerifiedIdentity {
		return nil, ErrLostFoundInvalidReturn
	}

	existing, err := s.repos.LostFound.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	if existing.Status == models.LostFoundStatusResolved {
		return nil, ErrLostFoundAlreadyReturned
	}
	if existing.ItemType != models.LostFoundTypeFound || existing.Status != models.LostFoundStatusClaimed {
		return nil, ErrLostFoundNotReturnable
	}

	claim, err := s.loadActiveClaim(ctx, id)
	if err != nil {
		return nil, err
	}
	if claim == nil {
		return nil, ErrLostFoundNoClaim
	}

	claimer, err := s.repos.User.FindByID(claim.ClaimedByUserId.String())
	if err != nil || claimer == nil {
		return nil, errors.New("failed to load claimer profile")
	}

	now := time.Now()
	existing.RecipientName = mappers.LostFoundClaimUserFullName(claimer)
	if existing.RecipientName == "" {
		existing.RecipientName = claimer.Email
	}
	existing.RecipientIdCard = strings.TrimSpace(claimer.IdCard)
	existing.RecipientPhone = strings.TrimSpace(claimer.Email)
	existing.VerifiedDescription = req.VerifiedDescription
	existing.VerifiedOwnership = req.VerifiedOwnership
	existing.VerifiedIdentity = req.VerifiedIdentity
	existing.ReturnedAt = &now
	existing.ReturnedByUserId = &staffID
	existing.Status = models.LostFoundStatusResolved
	if strings.TrimSpace(existing.DisplayCode) == "" {
		existing.DisplayCode = lostFoundDisplayCode(existing.Id)
	}

	claim.Status = models.LostFoundClaimApproved
	claim.ReviewedAt = &now
	claim.ReviewedByUserId = &staffID
	if _, err := s.repos.LostFoundClaim.Update(ctx, claim); err != nil {
		return nil, err
	}

	auditNote := fmt.Sprintf(
		"[%s] Hoàn trả cho %s (CCCD: %s, Email: %s) — xác nhận bởi nhân viên %s",
		now.Format(time.RFC3339),
		existing.RecipientName,
		maskIdCard(existing.RecipientIdCard),
		maskContact(existing.RecipientPhone),
		staffID.String(),
	)
	if existing.StaffNotes != "" {
		existing.StaffNotes = existing.StaffNotes + "\n" + auditNote
	} else {
		existing.StaffNotes = auditNote
	}

	updated, err := s.repos.LostFound.Update(ctx, existing)
	if err != nil {
		log.Printf("Error confirming lost and found return: %v", err)
		return nil, err
	}

	if s.notify != nil {
		label := strings.TrimSpace(existing.Title)
		if label == "" {
			label = "vật phẩm"
		}
		s.notify.NotifyUser(
			ctx,
			claim.ClaimedByUserId,
			"Đồ đã được trả",
			fmt.Sprintf("%s đã được xác nhận trả lại cho bạn.", label),
			constants.NotificationKindLostFound,
		)
	}

	resp := mappers.MapLostFoundToResponse(updated, nil)
	return &resp, nil
}

func maskIdCard(idCard string) string {
	trimmed := strings.TrimSpace(idCard)
	if len(trimmed) <= 3 {
		return strings.Repeat("x", len(trimmed))
	}
	return trimmed[:3] + strings.Repeat("x", len(trimmed)-3)
}

func maskContact(value string) string {
	trimmed := strings.TrimSpace(value)
	if len(trimmed) <= 3 {
		return strings.Repeat("x", len(trimmed))
	}
	at := strings.Index(trimmed, "@")
	if at > 1 {
		return trimmed[:2] + strings.Repeat("x", at-2) + trimmed[at:]
	}
	return trimmed[:3] + strings.Repeat("x", len(trimmed)-3)
}

func (s *LostFoundService) ensureTicketHolder(ctx context.Context, userIDStr string) error {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return errors.New("invalid user id")
	}

	userTicket, err := s.repos.Ticket.GetUserTicket(ctx, userID)
	if err != nil {
		log.Printf("Error checking user ticket for lost and found: %v", err)
		return errors.New("failed to check user ticket")
	}
	if userTicket == nil {
		return ErrLostFoundTicketRequired
	}
	if userTicket.Status != models.TicketStatusApproved && userTicket.Status != models.TicketStatusAdminGranted {
		return ErrLostFoundTicketNotApproved
	}
	return nil
}

func (s *LostFoundService) ListForTicketHolder(ctx context.Context, userIDStr string, q requests.ListLostFoundQuery) (*responses.LostFoundPublicListResponse, error) {
	if err := s.ensureTicketHolder(ctx, userIDStr); err != nil {
		return nil, err
	}

	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}

	q.ItemType = string(models.LostFoundTypeFound)
	q.Status = string(models.LostFoundStatusOpen)

	items, total, err := s.repos.LostFound.List(ctx, q)
	if err != nil {
		log.Printf("Error listing lost and found items for ticket holder: %v", err)
		return nil, err
	}

	claimStatusByItem := make(map[uuid.UUID]string, len(items))
	for _, item := range items {
		if claim, err := s.repos.LostFoundClaim.GetByItemAndUser(ctx, item.Id, userID); err == nil {
			claimStatusByItem[item.Id] = string(claim.Status)
		}
	}

	page := q.Page
	if page < 1 {
		page = 1
	}
	pageSize := q.PageSize
	if pageSize < 1 {
		pageSize = 20
	}
	if pageSize > 100 {
		pageSize = 100
	}

	totalPages := int(math.Ceil(float64(total) / float64(pageSize)))
	if total == 0 {
		totalPages = 0
	}

	return &responses.LostFoundPublicListResponse{
		Items:      mappers.MapLostFoundListToPublicResponse(items, claimStatusByItem),
		Total:      total,
		Page:       page,
		PageSize:   pageSize,
		TotalPages: totalPages,
	}, nil
}

func (s *LostFoundService) GetForTicketHolder(ctx context.Context, userIDStr, idStr string) (*responses.LostFoundPublicResponse, error) {
	if err := s.ensureTicketHolder(ctx, userIDStr); err != nil {
		return nil, err
	}

	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}

	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid item id")
	}

	item, err := s.repos.LostFound.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	if item.ItemType != models.LostFoundTypeFound || item.Status != models.LostFoundStatusOpen {
		return nil, ErrLostFoundNotFound
	}

	userClaimStatus := ""
	if claim, err := s.repos.LostFoundClaim.GetByItemAndUser(ctx, id, userID); err == nil {
		userClaimStatus = string(claim.Status)
	}

	resp := mappers.MapLostFoundToPublicResponse(item, userClaimStatus)
	return &resp, nil
}
