# FuveKonMobile

> ✅ **Source FuveKonMobile đã được clone chính xác.**
> Repository này chứa đầy đủ source code Flutter mobile app cùng với backend **Fuvekonse**
> tại thư mục `Fuvekonse/`.

---

## Cấu trúc Repository

| Thư mục | Nội dung |
|---|---|
| `/` (root) | Flutter mobile app (Dart/Flutter) |
| `Fuvekonse/` | Backend Go microservices |
| `Fuvekonse/services/general-service/` | Core API service (Go + Gin + PostgreSQL) |
| `Fuvekonse/services/rbac-service/` | Role-Based Access Control service |
| `Fuvekonse/services/sqs-worker/` | SQS Lambda worker |

---

## Quick Start (Mobile Dev)

Yêu cầu: [Go](https://go.dev/doc/install) >= 1.25, [Docker](https://www.docker.com/get-started/), [Flutter](https://docs.flutter.dev/get-started/install), [Task](https://taskfile.dev/installation/).

```powershell
# Cài Task runner (một lần)
go install github.com/go-task/task/v3/cmd/task@latest

# Setup backend một lần (tools, .env, Docker, migrate)
task backend:setup

# Terminal 1 — chạy backend local mỗi ngày
task backend:dev

# Terminal 2 — chạy mobile app
flutter pub get

# Windows desktop (khuyến nghị — không bị CORS)
flutter run -d windows

# Chrome web — phải dùng port 3000 (backend CORS chỉ cho localhost:3000, :3001)
flutter run -d chrome --web-port=3000
```

API local: http://localhost:8085/swagger/index.html

### Tài khoản test (seed)

`task backend:setup` tự chạy seed sau migration. Script: [`Fuvekonse/services/general-service/cmd/seed/main.go`](Fuvekonse/services/general-service/cmd/seed/main.go).

Chạy lại seed thủ công (idempotent — tạo mới hoặc cập nhật user):

```powershell
cd Fuvekonse/services/general-service
go run ./cmd/seed
```

| Email | Password | Role |
|---|---|---|
| `admin@fuve.com` | `admin123` | Admin |
| `user@fuve.com` | `user123` | User |
| `dealer@fuve.com` | `dealer123` | Dealer |
| `user@example.com` | `password123` | User (legacy) |

### `BASE_URL` theo nền tảng (file `.env`)

| Nền tảng | `BASE_URL` |
|---|---|
| Web / Windows / iOS Simulator | `http://localhost:8085/v1` |
| Android Emulator | `http://10.0.2.2:8085/v1` |
| Thiết bị thật | `http://<IP-máy-tính>:8085/v1` |

**Flutter Web + backend local:** trình duyệt chặn request nếu origin không nằm trong `CORS_ALLOWED_ORIGINS` của general-service (mặc định `http://localhost:3000`, `http://localhost:3001`). Chạy `flutter run -d chrome --web-port=3000` hoặc dùng `-d windows`.

> Task backend được định nghĩa tại [`Taskfile.yml`](Taskfile.yml) (root repo), không nằm trong `Fuvekonse/`.

---

## Task Runner (Quản lý Backend)

Repository này sử dụng [**Task**](https://taskfile.dev) tại root để quản lý backend local cho mobile dev.

### Các task

| Command | Mô tả |
|---|---|
| `task backend:setup` | Setup một lần (tools, env, Docker images, migrate, seed users) |
| `task backend:dev` | Chạy backend local mỗi ngày (infra + migrate + services) |
| `task backend:stop` | Dừng Docker infrastructure |

Xem đầy đủ: `task --list`

---

## Getting Started (Flutter)

Đây là project Flutter cơ bản. Một số tài nguyên hữu ích:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

Xem tài liệu đầy đủ tại [flutter.dev](https://docs.flutter.dev/) để biết thêm về tutorials, samples, và API reference.
