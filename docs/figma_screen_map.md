# FUVEKON — Figma screen map (customer)

Figma file: [FUVE-for-PRM](https://www.figma.com/design/yzSZQWX1PB79nSbNMbKUXj/FUVE-for-PRM?node-id=768-36)

| Figma | Screen | Node ID | Route | Dart file |
|-------|--------|---------|-------|-----------|
| Màn 12 | Trang chủ | TBD | `/account` | `lib/screens/account/pages/authenticated_home_page.dart` |
| Màn 16 | Lịch trình tổng | TBD | `/account/schedule` | `lib/features/schedule/presentation/pages/schedule_page.dart` |
| Màn 17 | Chi tiết hoạt động | TBD | `/account/schedule/activity/:id` | `lib/features/schedule/presentation/pages/activity_detail_page.dart` |
| Màn 13 | Chi tiết sự kiện | TBD | `/account/schedule/event/:id` | `lib/features/schedule/presentation/pages/event_detail_page.dart` |
| Màn 14 | Bản đồ | TBD | `/account/schedule/map` | `lib/features/schedule/presentation/pages/venue_map_page.dart` |
| Màn 15 | Chi tiết địa điểm | TBD | `/account/schedule/venue/:id` | `lib/features/schedule/presentation/pages/venue_detail_page.dart` |
| Màn 20 | Lịch trình cá nhân | TBD | `/account/schedule/my` | `lib/features/schedule/presentation/pages/my_itinerary_page.dart` |
| Màn 21–22 | Thông tin vé | TBD | `/ticket`, `/ticket/purchase` | `lib/features/ticket/presentation/pages/tickets_page.dart` |
| Màn 26–27 | Vé của tôi + QR | TBD | `/account/ticket` | `lib/features/ticket/presentation/pages/my_ticket_page.dart` |
| Màn 28 | Nâng cấp vé | TBD | `/account/ticket/upgrade` | `lib/features/ticket/presentation/pages/ticket_upgrade_page.dart` |
| Màn 31 | Thông báo | TBD | `/account/notifications` | `lib/features/notification/presentation/pages/notifications_page.dart` |
| Màn 32 | Chi tiết TB | TBD | `/account/notifications/:id` | `lib/features/notification/presentation/pages/notification_detail_page.dart` |
| Màn 35 | L&F chi tiết | TBD | `/lost-found/:id` | `lib/screens/info/lost_found_detail_page.dart` |
| Màn 36 | Báo mất | TBD | `/lost-found/report` | `lib/screens/info/lost_found_report_page.dart` |
| Màn 37 | Theo dõi | TBD | `/lost-found/requests/:id` | `lib/screens/info/lost_found_request_page.dart` |
| Màn 38–42 | Tài khoản | TBD | `/account/profile/*` | `lib/features/profile/presentation/pages/` |

Update node IDs via Figma MCP `get_design_context` when refining individual screens.
