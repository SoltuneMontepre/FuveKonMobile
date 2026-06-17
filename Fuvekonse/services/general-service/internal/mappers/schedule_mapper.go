package mappers

import (
	"general-service/internal/dto/schedule/responses"
	"general-service/internal/models"
	"sort"
	"time"
)

type timelineSource struct {
	item     models.ScheduleEvent
	category string
	location string
}

func MapScheduleToResponse(s *models.Schedule) responses.ScheduleResponse {
	sources := collectTimelineSources(s)

	return responses.ScheduleResponse{
		Id:                s.Id,
		Name:              s.Name,
		StartAt:           s.StartAt,
		EndAt:             s.EndAt,
		DayCount:          countScheduleDays(s.StartAt, s.EndAt),
		TimelineItemCount: len(sources),
		Days:              buildScheduleDays(s.StartAt, s.EndAt, sources),
		CreatedAt:         s.CreatedAt,
		ModifiedAt:        s.ModifiedAt,
	}
}

func MapSchedulesToResponse(items []models.Schedule) []responses.ScheduleResponse {
	out := make([]responses.ScheduleResponse, len(items))
	for i := range items {
		out[i] = MapScheduleToResponse(&items[i])
	}
	return out
}

func MapTimelineItemToResponse(
	e *models.ScheduleEvent,
	category string,
	location string,
) responses.TimelineItemResponse {
	return responses.TimelineItemResponse{
		Id:          e.Id,
		Title:       e.Title,
		Description: e.Description,
		StartAt:     e.StartAt,
		EndAt:       e.EndAt,
		Category:    category,
		Location:    location,
		CreatedAt:   e.CreatedAt,
		ModifiedAt:  e.ModifiedAt,
	}
}

func collectTimelineSources(s *models.Schedule) []timelineSource {
	sources := make([]timelineSource, 0)
	for i := range s.Venues {
		v := s.Venues[i]
		for j := range v.Locations {
			l := v.Locations[j]
			for k := range l.Events {
				sources = append(sources, timelineSource{
					item:     l.Events[k],
					category: v.Name,
					location: l.Name,
				})
			}
		}
	}
	return sources
}

func countScheduleDays(startAt, endAt *time.Time) int {
	if startAt == nil || endAt == nil {
		return 0
	}
	first := truncateToDate(*startAt)
	last := truncateToDate(*endAt)
	if last.Before(first) {
		return 0
	}
	return int(last.Sub(first).Hours()/24) + 1
}

func buildScheduleDays(
	startAt *time.Time,
	endAt *time.Time,
	sources []timelineSource,
) []responses.ScheduleDayResponse {
	if startAt == nil || endAt == nil {
		return []responses.ScheduleDayResponse{}
	}

	first := truncateToDate(*startAt)
	last := truncateToDate(*endAt)
	if last.Before(first) {
		return []responses.ScheduleDayResponse{}
	}

	byDate := make(map[string][]responses.TimelineItemResponse)
	for cursor := first; !cursor.After(last); cursor = cursor.AddDate(0, 0, 1) {
		byDate[cursor.Format("2006-01-02")] = []responses.TimelineItemResponse{}
	}

	for _, src := range sources {
		dateKey := src.item.StartAt.Format("2006-01-02")
		if _, ok := byDate[dateKey]; !ok {
			continue
		}
		byDate[dateKey] = append(byDate[dateKey], MapTimelineItemToResponse(
			&src.item,
			src.category,
			src.location,
		))
	}

	days := make([]responses.ScheduleDayResponse, 0, len(byDate))
	for cursor := first; !cursor.After(last); cursor = cursor.AddDate(0, 0, 1) {
		dateKey := cursor.Format("2006-01-02")
		items := byDate[dateKey]
		sort.Slice(items, func(i, j int) bool {
			return items[i].StartAt.Before(items[j].StartAt)
		})
		days = append(days, responses.ScheduleDayResponse{
			Date:     dateKey,
			Timeline: items,
		})
	}

	return days
}

func truncateToDate(value time.Time) time.Time {
	y, m, d := value.Date()
	return time.Date(y, m, d, 0, 0, 0, 0, value.Location())
}
