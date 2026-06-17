# API gap analysis — FUVEKON mobile customer app

This document tracks backend endpoints that the mobile client needs but are missing, incomplete, or not yet mapped in the Flutter data layer. Phase 2 schedule/itinerary work uses mock data until these gaps are closed.

## Schedule (public)

| Need | Current API | Gap | Mobile stub |
|------|-------------|-----|-------------|
| List published schedules | `GET /schedules` via `ScheduleApi.listSchedules()` | Response shape not mapped to `ScheduleEvent` + nested venues/locations/events | `ScheduleRepositoryImpl.listScheduleEvents()` returns not-wired error after HTTP call |
| Schedule detail | `GET /schedules/:id` via `ScheduleApi.getSchedule()` | Same — no DTO → domain mapping | `ScheduleRepositoryImpl.getScheduleEvent()` |
| Activities by day/venue | — | No dedicated customer endpoint; likely embedded in schedule detail or needs `GET /schedules/:id/activities?day=&venue=` | Mock only in `MockScheduleRepository.listActivities()` |
| Activity detail | — | No `GET /schedules/.../activities/:id` (or equivalent) documented for mobile | Mock only in `MockScheduleRepository.getActivity()` |
| Venues list / detail | Admin-only `AdminVenueApi` | Public read endpoints for venue map (Màn 14–15) not exposed on `ScheduleApi` | Mock only |

### Suggested backend contract (schedule)

```
GET /schedules
GET /schedules/{id}                    → { id, name, description, start_at, end_at, venues[] }
GET /schedules/{id}/activities         → ?day=YYYY-MM-DD&venue_id=
GET /schedules/{id}/activities/{id}    → activity + venue/location labels
GET /schedules/{id}/venues             → venues with map_x, map_y, locations[]
GET /schedules/{id}/venues/{id}        → venue detail
```

## Itinerary (authenticated)

| Need | Current API | Gap | Mobile stub |
|------|-------------|-----|-------------|
| List my itinerary | — (SRS: `/account/itinerary`) | No client API class or path in `ApiConstants` | `MockScheduleRepository.getItinerary()` |
| Add bookmark | — | No `POST /users/me/itinerary` or similar | `MockScheduleRepository.addToItinerary()` |
| Remove bookmark | — | No `DELETE` | `MockScheduleRepository.removeFromItinerary()` |
| Conflict check | — | Could be client-side from itinerary list, or server returns 409 with conflicting item | `MockScheduleRepository.findItineraryConflict()` (client-side overlap) |

### Suggested backend contract (itinerary)

```
GET    /users/me/itinerary
POST   /users/me/itinerary           → { activity_id } ; 409 + conflicting activity on overlap
DELETE /users/me/itinerary/{activity_id}
```

### Màn 19 — bookmark conflict dialog

Mobile flow (implemented with mock):

1. User taps bookmark on activity detail.
2. Client checks overlap with existing itinerary items (`findItineraryConflict`).
3. If conflict → dialog: cancel or replace conflicting item.
4. On replace → remove conflict then add (`addToItinerary(replaceConflict: true)`).

When API ships, prefer server-side conflict detection (409) with conflicting activity payload in error body.

## Wiring checklist (Phase 3+)

- [ ] Add `ItineraryApi` (or extend `AccountApi`) with paths in `ApiConstants`
- [ ] Map schedule JSON to `ScheduleEvent`, `Venue`, `ScheduleActivity` (align with admin models in `admin_schedule_models.dart`)
- [ ] Switch `registerScheduleModule(sl, useMock: false)` in `injection.dart`
- [ ] Remove or gate `MockScheduleRepository` for production builds

## Lost & Found (customer — Màn 35–37)

| Need | Current API | Gap | Mobile behavior |
|------|-------------|-----|-----------------|
| Found item detail | `GET /lost-found/:id` via `LostFoundApi.getById()` | Only returns **open found** items; claimed/resolved items return 404 for ticket holders | Detail + track pages use `getById`; track falls back when status advances |
| Submit lost report | — | No `POST /lost-found/report` (or equivalent) on protected routes; admin-only `POST /admin/lost-found` exists | `LostFoundReportPage` calls `LostFoundApi.report()` → `POST /lost-found/report` (anticipated) |
| Track claim / report | — | No `GET /lost-found/requests/:id`; claim result only returns `item_id`, not claim id | `LostFoundRequestPage` tries `getRequest()` then falls back to `getById(itemId)` |
| List my requests | — | No `GET /lost-found/me/requests` for history after item leaves public board | User reaches track via post-claim/report navigation only |

### Suggested backend contract (lost & found — customer)

```
POST /lost-found/report              → item_type=lost payload (ticket holder)
GET  /lost-found/requests/:id        → claim or lost-report status for current user
GET  /lost-found/me/requests         → paginated list of user's claims and lost reports
GET  /lost-found/:id                 → extend to return non-open items when user has claim/report
```

### Related files

- `lib/core/api/lost_found_api.dart` — list, detail, claim, report, getRequest
- `lib/screens/info/lost_found_service.dart` — customer service layer
- `lib/screens/info/lost_found_detail_page.dart` — Màn 35
- `lib/screens/info/lost_found_report_page.dart` — Màn 36
- `lib/screens/info/lost_found_request_page.dart` — Màn 37

## Related files

- `lib/core/api/schedule_api.dart` — existing public schedule HTTP client
- `lib/features/schedule/data/repositories/schedule_repository_impl.dart` — stub impl
- `lib/features/schedule/data/repositories/mock_schedule_repository.dart` — Phase 2 mock data
- `lib/features/schedule/di/schedule_injection.dart` — `useMock` toggle
