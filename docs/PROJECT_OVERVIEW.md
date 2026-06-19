# FuveKon — Tài liệu dự án (Milestone 50%)

**Dự án:** FuveKon  
**Phiên bản tài liệu:** 1.0 — Milestone 50%  
**Deadline milestone:** 20/06/2026  
**Ngày cập nhật:** 19/06/2025  

---

## Mục lục

1. [Giới thiệu (Introduction)](#1-giới-thiệu-introduction)
2. [Phạm vi dự án (Project Scope)](#2-phạm-vi-dự-án-project-scope)
3. [Milestone 50% — Mục tiêu & tiến độ](#3-milestone-50--mục-tiêu--tiến-độ)
4. [Link tham chiếu](#4-link-tham-chiếu)
5. [Kỹ thuật (Technical)](#5-kỹ-thuật-technical)
6. [Tính năng & màn hình đã hoàn thành](#6-tính-năng--màn-hình-đã-hoàn-thành)
7. [Tính năng & màn hình chưa hoàn thành](#7-tính-năng--màn-hình-chưa-hoàn-thành)
8. [Các bước tiếp theo (Next Actions)](#8-các-bước-tiếp-theo-next-actions)
9. [Phụ lục](#9-phụ-lục)

---

## 1. Giới thiệu (Introduction)

**FuveKon** là hệ thống quản lý vé và người dùng cho sự kiện (convention / triển lãm), gồm các thành phần chính:

| Nhóm tính năng | Mô tả ngắn |
|---|---|
| Xác thực | Đăng nhập, đăng ký, OAuth2 (Google) |
| Vé | Mua vé, nâng cấp vé, quản lý vé, quét vé tại sự kiện |
| Đăng ký & quản lý | Dealer, Talent, Panel — đăng ký và quản trị hồ sơ |
| Hồ sơ | Quản lý profile, cài đặt, đổi mật khẩu |
| Sự kiện | Thông báo sự kiện, lịch trình, lịch trình cá nhân (itinerary) |
| Vận hành | Dashboard, quét vé (staff), quản trị admin |
| Khác | Lost & Found, hạ tầng cloud |

### Kiến trúc hệ thống

| Layer | Công nghệ |
|---|---|
| Frontend Web | Next.js |
| Mobile | Flutter (FuveKonMobile — repo này) |
| Backend | Gin (Go) — **Fuvekonse** |
| Database | PostgreSQL (production: NeonDB) |
| Cache | Redis |
| Cloud | AWS Lambda, S3, Cloudflare |

Repository **FuveKonMobile** là monorepo gồm:

- **Root `/`** — ứng dụng Flutter (Guest, Customer, Staff, Admin)
- **`Fuvekonse/`** — backend microservices (general-service, rbac-service, sqs-worker)

Thiết kế mobile theo hệ thống **FuveKon Premium Mobile**: dark mode luxury, thẻ mint, primary sage green, typography **Be Vietnam Pro**, hỗ trợ **Tiếng Việt / English**.

### Mục tiêu milestone hiện tại (50%)

Hoàn thành **50% khối lượng dự án** thông qua việc đóng gói một **Luồng Tính Năng Chính Hoàn Chỉnh (End-to-End Core Flow)**:

**Guest/Customer → Staff → Admin**

Yêu cầu: hệ thống vận hành **thực tế (không mock data)**, sẵn sàng **demo tiến độ** với Giảng viên hướng dẫn.

---

## 2. Phạm vi dự án (Project Scope)

### 2.1 Phạm vi toàn bộ ứng dụng FuveKon

| Phân hệ | Vai trò | Phạm vi chức năng |
|---|---|---|
| **Guest** | Khách chưa đăng nhập | Landing, xem sự kiện, khám phá vé, mua vé, FAQ, đăng ký tài khoản |
| **Customer** | Người dùng đã đăng nhập | Trang chủ, vé của tôi + QR, lịch trình, thông báo, profile, submissions, Lost & Found |
| **Staff** | Nhân viên sự kiện | Quét và check-in vé, lịch sử quét |
| **Admin** | Quản trị viên | Dashboard, quản lý vé/hạng vé, người dùng, lịch trình, Lost & Found, conbook, dealers, panels, hệ thống |
| **Backend** | API & hạ tầng | Auth, ticket, analytics, schedule, RBAC, queue (SQS), upload (S3) |

**Nền tảng mobile:** Android, iOS, Web (Chrome), Windows desktop.

### 2.2 Phạm vi trong milestone 50% (Deliverables bắt buộc)

Chỉ các hạng mục sau là **bắt buộc hoàn thành** trước 20/06/2026:

**Phân hệ Guest/Customer**

- Màn hình trang chủ, danh sách sự kiện, chi tiết sự kiện (Guest)
- Màn hình danh sách vé — trạng thái *Chưa có vé* và *Đã sở hữu vé*
- Giao diện và luồng Thanh toán (Payment) đặt mua vé
- Chi tiết vé hiển thị mã QR/Barcode — quét và nhận diện được

**Phân hệ Staff**

- Quét và kiểm tra vé tại sự kiện (check-in hợp lệ)

**Phân hệ Admin**

- Dashboard tổng quan — dữ liệu phản ánh đúng từ database

**Testing & dữ liệu demo**

- Seed đủ tài khoản: ≥1 Admin, ≥2 Staff, ≥2 Customer
- Seed 2–3 sự kiện sắp diễn ra (banner, mô tả, thời gian, địa điểm)
- Mỗi sự kiện có nhiều loại vé (VIP, Thường…) với giá và số lượng
- 1–2 vé đã thanh toán sẵn cho Customer — QR map đúng ID vé trong DB

**Tài liệu & nộp bài**

- Source zip (đã clean, không `node_modules`)
- File doc đầy đủ các mục trong tài liệu này

### 2.3 Ngoài phạm vi milestone 50%

Các module **đã có code/UI** nhưng **không thuộc tiêu chí nghiệm thu** milestone này:

- Lịch trình cá nhân (itinerary) — bookmark conflict
- Thông báo push/in-app (notification) — mock repository
- Lost & Found đầy đủ (report/track API)
- Dealer / Talent / Panel management nâng cao
- Release lên App Store / Google Play
- Frontend Next.js (repo riêng)

---

## 3. Milestone 50% — Mục tiêu & tiến độ

### 3.1 Acceptance Criteria (Tiêu chí nghiệm thu)

| # | Tiêu chí | Trạng thái | Ghi chú |
|---|---|---|---|
| AC-1 | **Real Data** — toàn bộ luồng core gọi API, không mock | 🟡 Đang thực hiện | Ticket có API thật nhưng debug mặc định bật `MOCK_TICKET_MODE`; Schedule & Notification vẫn mock |
| AC-2 | **E2E Flow** — Guest xem sự kiện → mua vé → thanh toán → QR | 🟡 Đang thực hiện | UI + API ticket sẵn sàng; cần tắt mock + seed events/tiers |
| AC-3 | **E2E Flow** — Staff quét QR → check-in thành công | 🟡 Đang thực hiện | `ScanTicketService` nối `AdminTicketApi`; thiếu tài khoản Staff + vé seed |
| AC-4 | **E2E Flow** — Dashboard Admin hiển thị đúng sau giao dịch | 🟡 Đang thực hiện | `AdminDashboardService` gọi `AnalyticsApi`; cần dữ liệu thật trong DB |
| AC-5 | **Test data** — đủ user/event/ticket theo spec | 🔴 Chưa đạt | Seed hiện chỉ có 4 user (1 admin, 2 customer, 1 dealer); chưa seed events/tickets |
| AC-6 | **Document** — doc đầy đủ + source zip clean | 🟡 Đang thực hiện | Doc này; zip cần team thực hiện trước deadline |

**Chú thích:** 🟢 Đạt · 🟡 Đang thực hiện · 🔴 Chưa đạt

### 3.2 Bảng đối chiếu Deliverables

| Deliverable (Trello) | Route / Module | UI | API thật | Seed data | Đánh giá |
|---|---|:---:|:---:|:---:|---|
| Guest — Trang chủ | `/` | ✅ | ➖ | ➖ | Landing marketing; chưa phải danh sách sự kiện động |
| Guest — Danh sách sự kiện | `/schedule`, `/ticket` | ✅ | 🟡 | 🔴 | Schedule dùng mock; cần nối `GET /schedules` |
| Guest — Chi tiết sự kiện | `/schedule/event/:id` | ✅ | 🟡 | 🔴 | UI xong; thiếu hero/banner từ API |
| Customer — Danh sách vé (chưa có / đã có) | `/ticket`, `/account/ticket` | ✅ | 🟡 | 🔴 | Phụ thuộc `MOCK_TICKET_MODE` |
| Customer — Thanh toán | `/ticket/purchase/:id` | ✅ | 🟡 | 🔴 | `purchaseTicket` + `confirmPayment` có API |
| Customer — Chi tiết vé + QR | `/account/ticket` | ✅ | 🟡 | 🔴 | QR = `referenceCode` từ API; scan staff lookup theo ID |
| Staff — Quét vé | `/admin/scan-ticket` | ✅ | ✅ | 🔴 | `lookupCode` + `checkInCode` qua API |
| Admin — Dashboard | `/admin/dashboard` | ✅ | ✅ | 🔴 | `AnalyticsApi.getDashboard()` |
| Seed users đủ role | `cmd/seed/main.go` | ➖ | ➖ | 🟡 | Có admin + 2 customer; **thiếu 2 staff** |
| Seed events + tiers | — | ➖ | ➖ | 🔴 | **Chưa có script seed** |
| Seed purchased tickets + QR | — | ➖ | ➖ | 🔴 | **Chưa có script seed** |

### 3.3 Ước lượng tiến độ milestone

| Hạng mục | Trọng số | % hoàn thành | Ghi chú |
|---|---:|---:|---|
| UI/Flow core (Guest → Payment → QR) | 25% | ~85% | Màn hình & navigation đã có |
| UI/Flow Staff + Admin | 15% | ~90% | Scan + Dashboard đã implement |
| Tích hợp API thật (tắt mock) | 25% | ~45% | Ticket gần xong; Schedule/Notification chưa thuộc milestone |
| Seed data & demo script | 20% | ~25% | Gap lớn nhất |
| E2E test & demo rehearsal | 10% | ~30% | Cần chạy sau khi seed xong |
| Tài liệu & nộp zip | 5% | ~70% | Doc đang hoàn thiện |
| **Tổng ước lượng milestone 50%** | **100%** | **~55%** | UI vượt trội; data + E2E cần đẩy nhanh |

> **Đề xuất:** Milestone 50% nên được định nghĩa là **“Core E2E Ticket Flow với real data”**, không gồm toàn bộ app. Phần Schedule, Notification, L&F, Submissions tiếp tục ở milestone 75%/100%.

---

## 4. Link tham chiếu

| Tài nguyên | Link |
|---|---|
| **Figma (thiết kế UI)** | `[LINK_FIGMA]` |
| **GitHub (source code)** | `[LINK_GITHUB]` |
| **Trello (milestone board)** | `[LINK_TRELLO]` |
| **Staging / Demo API** | `[LINK_STAGING_API]` |
| **Google Doc (bản nộp)** | `[LINK_GOOGLE_DOC]` |
| **Demo video (nếu có)** | `[LINK_DEMO_VIDEO]` |

**Gợi ý điền link:**

- Figma: file thiết kế FUVE-for-PRM (customer screens)
- GitHub: `https://github.com/SoltuneMontepre/FuveKonMobile` (hoặc org repo chính thức của nhóm)
- Staging API Swagger: `http://localhost:8085/swagger/index.html` (local) hoặc URL production/staging của team

---

## 5. Kỹ thuật (Technical)

### 5.1 Mobile — Flutter (FuveKonMobile)

| Hạng mục | Chi tiết |
|---|---|
| Ngôn ngữ | Dart ^3.11.1 |
| Framework | Flutter |
| Kiến trúc | Feature modules (presentation / domain / data) |
| State management | flutter_bloc, Cubit |
| Routing | go_router — StatefulShellRoute (bottom nav indexed stack) |
| Dependency injection | get_it |
| HTTP | dio |
| Serialization | freezed, json_serializable |
| Auth | JWT + flutter_secure_storage, Google Sign-In |
| i18n | flutter_localizations (vi, en) |
| QR | qr_flutter (hiển thị), mobile_scanner (quét staff) |
| Config | `.env` — `BASE_URL`, `MOCK_TICKET_MODE`, `GOOGLE_CLIENT_ID` |

**Cấu trúc thư mục:**

```
lib/
├── core/           router, DI, API client, theme, config
├── features/       auth, ticket, schedule, notification, profile
├── screens/        account shell, admin, public, info, contribute
├── shared/         widgets, services dùng chung
└── l10n/           bản dịch
```

**Chế độ mock hiện tại (cần tắt cho milestone):**

| Module | Cấu hình | Ảnh hưởng milestone |
|---|---|---|
| Ticket | `MOCK_TICKET_MODE=true` (mặc định debug) | **Trực tiếp** — set `false` trong `.env` |
| Schedule | `useMock: true` trong `injection.dart` | Ngoài scope milestone nếu Guest events lấy từ ticket tiers; **trong scope** nếu demo qua `/schedule` |
| Notification | `MockNotificationRepository` | Ngoài scope milestone 50% |

### 5.2 Backend — Fuvekonse

| Hạng mục | Chi tiết |
|---|---|
| Ngôn ngữ | Go >= 1.25 |
| Framework | Gin |
| ORM | GORM |
| Database | PostgreSQL |
| Cache | Redis |
| Local dev | Docker Compose + LocalStack (S3, SQS, SES) |
| Services | general-service, rbac-service, sqs-worker |
| Task runner | `Taskfile.yml` tại root — `task backend:setup`, `task backend:dev` |

**API local:** `http://localhost:8085/swagger/index.html`

**Vai trò hệ thống (RBAC):**

| Role | Constant | Routing mobile sau login |
|---|---|---|
| User | `RoleUser` | `/account` |
| Dealer | `RoleDealer` | `/account` (+ dealer flows) |
| Staff | `RoleStaff` | `/admin` |
| Admin | `RoleAdmin` | `/admin` |

### 5.3 Luồng kỹ thuật E2E (Core Flow)

```
Guest/Customer                          Backend                         Staff/Admin
─────────────────                       ───────                         ───────────
Xem sự kiện / hạng vé          →        GET /schedules, GET /ticket-tiers
Chọn vé → Purchase             →        POST purchase (+ queue nếu 202)
Thanh toán → Confirm           →        POST confirm-payment
Xem QR (referenceCode)         ←        GET /users/me/ticket
Staff quét QR                  →        GET /admin/tickets/:id
Xác nhận check-in              →        POST check-in
Dashboard cập nhật             ←        GET /analytics/dashboard
```

### 5.4 Môi trường dev nhanh

```powershell
# Setup backend (một lần)
task backend:setup

# Chạy backend
task backend:dev

# Mobile — tắt mock ticket
# Trong .env: MOCK_TICKET_MODE=false
# BASE_URL=http://localhost:8085/v1

flutter pub get
flutter run -d windows
```

---

## 6. Tính năng & màn hình đã hoàn thành

> Phần này liệt kê **toàn bộ app**. Cột **Milestone 50%** đánh dấu hạng mục thuộc deliverables bắt buộc.

### 6.1 Auth & Onboarding

| Màn hình | Route | Milestone 50% | Ghi chú |
|---|---|:---:|---|
| Đăng nhập | `/login` | ➖ | API ✅ |
| Đăng ký | `/register` | ➖ | API ✅ |
| Google OAuth | `/register/google` | ➖ | ✅ |
| OTP | `/register/verify-otp` | ➖ | ✅ |
| Quên mật khẩu | `/forgot-password` | ➖ | ✅ |
| Terms / Event rules | `/tos` | ➖ | ✅ |

### 6.2 Guest / Public

| Màn hình | Route | Milestone 50% | Ghi chú |
|---|---|:---:|---|
| Landing / Trang chủ Guest | `/` | ✅ | UI ✅ — hero tĩnh, CTA mua vé |
| Khám phá vé / danh sách hạng vé | `/ticket` | ✅ | UI ✅ — trạng thái có/không vé |
| Chi tiết hạng vé | `/ticket/:id` | ✅ | UI ✅ |
| Mua vé & thanh toán | `/ticket/purchase/:id` | ✅ | UI ✅ — bank QR, confirm payment |
| Lịch trình (public) | `/schedule` | ✅ | UI ✅ — data mock |
| Chi tiết sự kiện | `/schedule/event/:id` | ✅ | UI ✅ |
| FAQ, Artbook, đăng ký form | các route public | ➖ | UI ✅ |

### 6.3 Customer (Account shell)

| Màn hình | Route | Milestone 50% | Ghi chú |
|---|---|:---:|---|
| Trang chủ (đã login) | `/account` | ➖ | UI ✅ |
| Vé của tôi | `/account/ticket` | ✅ | UI ✅ + QR `referenceCode` |
| Nâng cấp vé | `/account/ticket/upgrade` | ➖ | UI ✅ |
| E-ticket detail | `/account/ticket/:id` | ✅ | UI ✅ |
| Lịch trình, thông báo, profile | `/account/*` | ➖ | UI ✅ — ngoài milestone 50% |

### 6.4 Staff & Admin

| Màn hình | Route | Milestone 50% | Ghi chú |
|---|---|:---:|---|
| **Quét vé (Staff)** | `/admin/scan-ticket` | ✅ | UI ✅ + API lookup/check-in |
| Lịch sử quét | `/admin/history` | ➖ | ✅ |
| **Dashboard Admin** | `/admin/dashboard` | ✅ | UI ✅ + Analytics API |
| Quản lý vé | `/admin/tickets` | ➖ | ✅ |
| Quản lý users, schedules, L&F | `/admin/*` | ➖ | ✅ (phần lớn) |

### 6.5 Backend & hạ tầng

| Hạng mục | Milestone 50% | Ghi chú |
|---|---|---|
| general-service (auth, ticket, analytics) | ✅ | API core flow |
| rbac-service | ➖ | Roles Staff/Admin |
| Docker local stack | ✅ | `task backend:dev` |
| Seed users cơ bản | 🟡 | 1 admin, 2 customer — thiếu staff |

---

## 7. Tính năng & màn hình chưa hoàn thành

### 7.1 Gap so với milestone 50% (ưu tiên cao)

| # | Hạng mục | Trạng thái | Cần làm |
|---|---|---|---|
| G1 | **Tắt mock ticket** | 🔴 | `MOCK_TICKET_MODE=false`; verify purchase → confirm → my ticket |
| G2 | **Seed 2 tài khoản Staff** | 🔴 | Thêm vào `cmd/seed/main.go` (role `RoleStaff`) |
| G3 | **Seed 2–3 events + ticket tiers** | 🔴 | Script seed: banner URL, mô tả, thời gian, địa điểm, VIP/Standard |
| G4 | **Seed 1–2 vé đã mua + approved** | 🔴 | Gán cho customer; `reference_code` = ID staff quét được |
| G5 | **Guest event list từ DB** | 🟡 | Nối schedule API HOẶC dùng ticket tiers/events endpoint — quyết định 1 nguồn demo |
| G6 | **Rehearsal E2E + checklist** | 🔴 | Chạy full flow, ghi lại demo |
| G7 | **Source zip clean** | 🔴 | Loại `node_modules`, `.dart_tool`, build artifacts |

### 7.2 Màn hình placeholder (ngoài milestone 50%)

| Màn hình | Route |
|---|---|
| Reset password | `/reset-password` |
| About | `/about` |
| Recap | `/recap` |
| Admin Dashboard Users analytics | `/admin/dashboard/users` |
| Admin Talent management | `/admin/talents` |

### 7.3 Module có UI nhưng chưa real data (milestone 75%+)

| Module | Gap |
|---|---|
| Schedule / Itinerary | `useMock: true`; thiếu itinerary API |
| Notification | `MockNotificationRepository` |
| Lost & Found (report/track) | API customer chưa đủ |
| Featured event (home) | Thiếu `GET /events/featured` |
| Submissions / Dealer fallback | Mock khi API trống |

Chi tiết API gap: `docs/api_gap.md`

---

## 8. Các bước tiếp theo (Next Actions)

### Tuần 1 — Real data & seed (blocker lớn nhất)

1. Mở rộng `Fuvekonse/services/general-service/cmd/seed/main.go`:
   - `staff1@fuve.com`, `staff2@fuve.com` (role Staff)
   - `customer2@fuve.com` (role User) nếu cần tách demo
   - 2–3 schedules/events published + hero image URL
   - Ticket tiers (VIP, Standard) với price + stock
   - 1–2 tickets status `approved` gán cho `user@fuve.com`
2. Set `.env`: `MOCK_TICKET_MODE=false`, `BASE_URL=http://localhost:8085/v1`
3. Chạy `task backend:setup` (migrate + seed) trên máy demo

### Tuần 2 — E2E verification

4. **Flow A (mua mới):** Guest → `/ticket` → purchase → confirm → `/account/ticket` → hiện QR
5. **Flow B (vé sẵn):** Login customer có vé seed → QR → Staff scan → check-in OK
6. **Flow C (admin):** Login admin → Dashboard → số liệu ticket/revenue khớp sau Flow A/B
7. Ghi **Demo script** 5–10 phút cho Giảng viên (từng bước + tài khoản)

### Tuần 3 — Đóng gói milestone

8. Quyết định nguồn “danh sách sự kiện Guest”: `/schedule` (nối API) hoặc `/ticket` (tiers grouped) — implement tối thiểu 1 cách **real data**
9. Chạy regression: staff login routing, CORS web nếu demo Chrome (`--web-port=3000`)
10. Tạo **source zip clean** + upload lên `[LINK_GOOGLE_DRIVE_ZIP]`
11. Copy tài liệu này sang **Google Doc** → điền placeholder links → nộp

### Sau milestone 50% (roadmap 75% / 100%)

- Nối Schedule + Itinerary API; tắt `MockScheduleRepository`
- Notification API thật
- Lost & Found customer endpoints
- Hoàn thiện placeholder screens
- Next.js web parity (nếu trong scope đồ án)

---

## 9. Phụ lục

### 9.1 Tài khoản test hiện có (seed)

| Email | Password | Role | Đủ milestone? |
|---|---|---|---|
| `admin@fuve.com` | `admin123` | Admin | ✅ (cần 1) |
| `user@fuve.com` | `user123` | Customer | ✅ (cần ≥2 — thêm 1) |
| `user@example.com` | `password123` | Customer | ✅ (customer thứ 2) |
| `dealer@fuve.com` | `dealer123` | Dealer | ➖ (ngoài milestone) |
| *(chưa có)* | — | Staff ×2 | 🔴 **Cần bổ sung** |

### 9.2 Kịch bản demo đề xuất (5–7 phút)

1. **Guest** — Mở app, xem trang chủ + danh sách sự kiện/hạng vé (real data)
2. **Customer** — Login `user@fuve.com` → mua vé Standard → thanh toán → xem QR
3. **Staff** — Login `staff1@fuve.com` → Quét vé → Check-in thành công
4. **Admin** — Login `admin@fuve.com` → Dashboard: +1 approved, check-in reflected
5. *(Tuỳ chọn)* Customer thứ 2 login — vé seed sẵn — quét nhanh không cần mua lại

### 9.3 Tài liệu liên quan trong repo

| File | Nội dung |
|---|---|
| `README.md` | Quick start dev |
| `docs/figma_screen_map.md` | Map Figma ↔ route ↔ Dart |
| `docs/api_gap.md` | Phân tích gap API |
| `docs/manual_test_checklist.md` | QA checklist |
| `color.md` | Design tokens |
| `Fuvekonse/README.md` | Backend setup |

### 9.4 Hướng dẫn tạo Google Doc từ file này

1. Mở [Google Docs](https://docs.google.com) → **File → New → Document**
2. Mở file `docs/PROJECT_OVERVIEW.md` trong repo → **Select All → Copy**
3. Paste vào Google Doc → chỉnh heading (Heading 1/2) nếu cần
4. Thay các placeholder `[LINK_...]` bằng link thật của nhóm
5. **File → Download** (PDF) để nộp kèm nếu GV yêu cầu PDF

*Hoặc:* Upload file `.md` lên Google Drive → Open with Google Docs (convert tự động).

---

**FuveKon — Milestone 50% Documentation**  
*Nội bộ nhóm phát triển · Cập nhật trước deadline 20/06/2026*
