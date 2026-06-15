package services

import (
	"context"
	"errors"
	"general-service/internal/dto/lostfound/requests"
	"general-service/internal/dto/lostfound/responses"
	"general-service/internal/mappers"
	"general-service/internal/models"
	"general-service/internal/repositories"
	"log"
	"math"
	"strings"

	"github.com/google/uuid"
)

var ErrLostFoundNotFound = repositories.ErrLostFoundNotFound

var (
	ErrLostFoundTicketRequired = errors.New("user must have a ticket to view lost and found")
	ErrLostFoundTicketNotApproved = errors.New("user ticket must be approved to view lost and found")
)

type LostFoundService struct {
	repos *repositories.Repositories
}

func NewLostFoundService(repos *repositories.Repositories) *LostFoundService {
	return &LostFoundService{repos: repos}
}

func (s *LostFoundService) Create(ctx context.Context, userIDStr string, req *requests.CreateLostFoundRequest) (*responses.LostFoundResponse, error) {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}

	item := &models.LostFoundItem{
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

	resp := mappers.MapLostFoundToResponse(created)
	return &resp, nil
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

	resp := mappers.MapLostFoundToResponse(item)
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

	resp := mappers.MapLostFoundToResponse(updated)
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

	resp := mappers.MapLostFoundToResponse(item)
	return &resp, nil
}

func (s *LostFoundService) Delete(ctx context.Context, idStr string) error {
	id, err := uuid.Parse(idStr)
	if err != nil {
		return errors.New("invalid item id")
	}

	return s.repos.LostFound.Delete(ctx, id)
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

	// Ticket holders only see active (open) listings.
	q.Status = string(models.LostFoundStatusOpen)

	items, total, err := s.repos.LostFound.List(ctx, q)
	if err != nil {
		log.Printf("Error listing lost and found items for ticket holder: %v", err)
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

	return &responses.LostFoundPublicListResponse{
		Items:      mappers.MapLostFoundListToPublicResponse(items),
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

	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid item id")
	}

	item, err := s.repos.LostFound.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	if item.Status != models.LostFoundStatusOpen {
		return nil, ErrLostFoundNotFound
	}

	resp := mappers.MapLostFoundToPublicResponse(item)
	return &resp, nil
}
