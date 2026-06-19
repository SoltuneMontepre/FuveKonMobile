# API gap analysis — FUVEKON mobile customer app

Tracks backend endpoints vs mobile wiring. Last updated after Notifications + Schedule hybrid wiring.

## Wired (production mobile)

| Feature | Endpoints | Mobile layer | Notes |
|---------|-----------|--------------|-------|
| **Notifications** (Màn 31–32) | `GET /notifications`, `GET /notifications/:id`, `PUT /notifications/:id` (`mark_read`) | `NotificationApi`, `NotificationRepositoryImpl`, `notification_injection.dart` | Mock removed from DI |
| **Schedule list/detail/activities** (Màn 13–20 core) | `GET /schedules`, `GET /schedules/:id` | `ScheduleApi`, `ScheduleRepositoryImpl`, `schedule_mapper.dart` | Timeline from `days[].timeline[]` |
| **Schedule itinerary** (Màn 19) | — | In-memory in `ScheduleRepositoryImpl` | Uses API-cached activities; no backend yet |
| **Lost & Found list/detail/claim** (Màn 35) | `GET /lost-found`, `GET /lost-found/:id`, `POST /lost-found/:id/claim` | `LostFoundApi`, `LostFoundService` | Requires approved ticket |
| **Tickets** (explore, purchase, my ticket, upgrade) | `GET /tickets/tiers`, `GET /tickets/tiers/:id`, `GET /tickets/me`, `POST /tickets/purchase`, `PATCH /tickets/me/*` | `TicketApi`, `TicketRepositoryImpl` | Real API when `MOCK_TICKET_MODE=false` in `.env`; debug default unchanged for team testing |

### Mobile files wired

- `lib/core/api/notification_api.dart`
- `lib/features/notification/data/repositories/notification_repository_impl.dart`
- `lib/features/schedule/data/mappers/schedule_mapper.dart`
- `lib/features/schedule/data/repositories/schedule_repository_impl.dart`
- `lib/core/di/injection.dart` — `registerScheduleModule(sl, useMock: false)`
- `lib/features/notification/di/notification_injection.dart` — no mock in DI

---

## Hybrid / local mock (documented)

| Feature | Why mock/local | Mobile behavior |
|---------|----------------|-----------------|
| **Venue map** (Màn 14–15) | No public `GET /venues`; admin-only | `ScheduleRepositoryImpl` delegates `listVenues` / `getVenue` to `MockScheduleRepository` |
| **Itinerary bookmarks** | No `GET/POST/DELETE /users/me/itinerary` | Stored in-memory on `ScheduleRepositoryImpl` against API activity IDs |
| **Tickets (debug)** | Team manual testing | `MOCK_TICKET_MODE` defaults on in debug; `MockTicketRepository` + demo overlay |

---

## Still missing (backend or mapping)

### Featured events (home — Màn 12 → Màn 13)

| Need | Current API | Gap | Mobile behavior |
|------|-------------|-----|-----------------|
| Home featured event card | — | No `GET /events/featured` | `kHomeFeaturedEvent` const in `featured_event_summary.dart` |
| Event detail marketing | `GET /schedules/:id` | No `hero_image_url`, `tags`, `location_label` | Defaults in `ScheduleEvent` mapper |

```
GET /events/featured              → { id, title, description, location_label, start_at, end_at, hero_image_url, tags[] }
GET /schedules/{id}               → extend with hero_image_url, tags[], location_label
```

### Schedule (remaining)

| Need | Gap | Mobile behavior |
|------|-----|-----------------|
| Public venue read | Admin-only `GET /admin/venues` | Mock delegate for map |
| Dedicated activity endpoint | Embedded in schedule detail | Client filters cached timeline |
| Persisted itinerary | No `/users/me/itinerary` | Session-local only |

```
GET /schedules/{id}/venues             → venues with map_x, map_y, locations[]
GET    /users/me/itinerary
POST   /users/me/itinerary           → 409 on overlap
DELETE /users/me/itinerary/{activity_id}
```

### Lost & Found (Màn 36–37)

| Need | Gap | Mobile behavior |
|------|-----|-----------------|
| Submit lost report | No `POST /lost-found/report` | `LostFoundReportPage` anticipates endpoint |
| Track claim/report | No `GET /lost-found/requests/:id` | Falls back to `getById` |
| List my requests | No `GET /lost-found/me/requests` | Navigate-only after claim |

```
POST /lost-found/report
GET  /lost-found/requests/:id
GET  /lost-found/me/requests
```

---

## Wiring checklist

- [x] Add `NotificationApi` + paths in `ApiConstants`
- [x] Map schedule JSON to `ScheduleEvent`, `ScheduleActivity` via `schedule_mapper.dart`
- [x] Switch `registerScheduleModule(sl, useMock: false)` in `injection.dart`
- [x] Remove `MockNotificationRepository` from production DI
- [ ] Add `ItineraryApi` when backend ships
- [ ] Public venue endpoints for customer map
- [ ] Featured events endpoint or extend schedule payload
- [ ] L&F report + track request endpoints

### Màn 19 — bookmark conflict dialog

1. User taps bookmark on activity detail.
2. Client checks overlap with in-memory itinerary (`findItineraryConflict`).
3. If conflict → dialog: cancel or replace.
4. On replace → remove conflict then add.

When API ships, prefer server-side 409 with conflicting activity in error body.

---

## Related files

- `lib/core/api/schedule_api.dart`
- `lib/features/schedule/data/repositories/schedule_repository_impl.dart`
- `lib/features/schedule/data/repositories/mock_schedule_repository.dart` — venue delegate + full mock when `useMock: true`
- `lib/features/schedule/di/schedule_injection.dart`
- `lib/core/api/lost_found_api.dart`
- `lib/screens/info/lost_found_service.dart`
- `lib/features/ticket/di/ticket_injection.dart` — mock toggle via `AppConfig.mockTicketMode`
