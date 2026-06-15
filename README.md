# FuveKonMobile

> ✅ **Source FuveKonMobile đã được clone chính xác.**
> Repository này chứa đầy đủ source code Flutter mobile app cùng với backend **Fuvekonse**
> được tích hợp dưới dạng **Git Subtree** tại thư mục `Fuvekonse/`.

---

## Cấu trúc Repository

| Thư mục | Nội dung |
|---|---|
| `/` (root) | Flutter mobile app (Dart/Flutter) |
| `Fuvekonse/` | Backend Go microservices — **git subtree** từ [`SoltuneMontepre/Fuvekonse`](https://github.com/SoltuneMontepre/Fuvekonse) |
| `Fuvekonse/services/general-service/` | Core API service (Go + Gin + PostgreSQL) |
| `Fuvekonse/services/rbac-service/` | Role-Based Access Control service |
| `Fuvekonse/services/sqs-worker/` | SQS Lambda worker |

> [!NOTE]
> **Fuvekonse** là git subtree — không phải submodule. Source code được copy trực tiếp vào repo này.
> Mọi thay đổi push lên `FuveKonMobile` sẽ **không ảnh hưởng** đến repo backend gốc.

---

## Task Runner (Quản lý Backend)

Repository này sử dụng [**Task**](https://taskfile.dev) để quản lý các tác vụ backend.

### Cài đặt Task runner

```bash
go install github.com/go-task/task/v3/cmd/task@latest
```

Hoặc xem các phương thức cài đặt khác tại [taskfile.dev/installation](https://taskfile.dev/installation/).

### Xem tất cả task

```bash
task --list
```

### Các task phổ biến

| Command | Mô tả |
|---|---|
| `subtree-pull` | Pull latest Fuvekonse từ GitHub vào git subtree |
| `backend` | Chạy toàn bộ dev environment (alias của `backend:default`) |
| `backend:dev` | Start Docker infra + migrate + chạy tất cả services với Air |
| `backend:infra` | Khởi động Docker infrastructure (PostgreSQL, Redis, LocalStack) |
| `backend:stop` | Dừng Docker infrastructure |
| `backend:migrate` | Chạy database migration cho general-service |
| `backend:run:general` | Chạy general-service với Air |
| `backend:run:rbac` | Chạy rbac-service với Air |
| `backend:run:worker` | Chạy sqs-worker với Air |
| `backend:services` | Chạy tất cả services với Air (song song) |
| `backend:check` | Kiểm tra prerequisites và port availability |
| `backend:tools` | Cài đặt Go dev tools cần thiết |
| `backend:env` | Tạo/cập nhật file `.env` cho các service |
| `backend:wait` | Chờ Postgres, Redis, LocalStack sẵn sàng |
| `backend:build:general` | Build general-service (Docker, cho Lambda) |
| `backend:build:rbac` | Build rbac-service (Docker, cho Lambda) |
| `backend:build:worker` | Build sqs-worker (Docker, cho Lambda) |
| `backend:build:lambda` | Build tất cả services cho AWS Lambda |
| `backend:build:local` | Build tất cả services locally |


---

## Backend Integration (Git Subtree)

Backend `Fuvekonse` được tích hợp vào repository này dưới thư mục `Fuvekonse/` sử dụng Git Subtree.

### Cập nhật backend từ upstream

```bash
# Dùng Task runner (khuyến nghị):
task backend:subtree-pull

# Hoặc chạy thủ công:
git subtree pull --prefix Fuvekonse https://github.com/SoltuneMontepre/Fuvekonse.git main --squash
```

### An toàn khi push

Vì Fuvekonse là **git subtree** (không phải submodule), các lệnh push thông thường (`git push origin main`) chỉ ảnh hưởng đến repo mobile này. **Không có rủi ro push ngược lên repo backend gốc.**

---

### ⚠️ Quyền hạn của Mobile Developer đối với Backend

> [!WARNING]
> **Mobile developer chỉ có quyền chạy source backend — KHÔNG có quyền commit thay đổi trực tiếp lên repo backend gốc.**
>
> Mọi thay đổi trong thư mục `Fuvekonse/` phải được:
> 1. **Document lại đầy đủ** — lý do thay đổi, phạm vi ảnh hưởng, cách test
> 2. **Tách thành commit riêng biệt** — không trộn lẫn với commit mobile
> 3. **Đặt trên nhánh riêng** với prefix `backend/<ten-van-de>`
> 4. **Propose lên maintainer** của [`SoltuneMontepre/Fuvekonse`](https://github.com/SoltuneMontepre/Fuvekonse) để review và cherry-pick

### Quy trình propose thay đổi backend

Khi bắt buộc phải sửa source backend trong quá trình phát triển mobile:

**Bước 1 — Tạo nhánh riêng cho thay đổi backend:**

```bash
# Đặt tên nhánh theo prefix backend/
git checkout -b backend/<ten-van-de>

# Ví dụ:
git checkout -b backend/fix-auth-token-expiry
git checkout -b backend/feat-push-notification-endpoint
```

**Bước 2 — Commit riêng biệt, chỉ chứa thay đổi backend:**

```bash
# Chỉ stage các file trong Fuvekonse/
git add Fuvekonse/

# Commit message rõ ràng, giải thích lý do
git commit -m "fix(auth): correct token expiry handling in general-service

[BACKEND CHANGE PROPOSAL]
- Reason: Mobile app receives 401 unexpectedly after 30min
- Scope: Fuvekonse/services/general-service/internal/middleware/auth.go
- Tested: Local dev with docker compose + air
- Request: Cherry-pick to SoltuneMontepre/Fuvekonse main branch"
```

**Bước 3 — Document thay đổi:**

Điền vào template tại [`docs/backend-change-proposal.md`](docs/backend-change-proposal.md) và attach vào message gửi maintainer.

**Bước 4 — Thông báo cho maintainer backend:**

Liên hệ maintainer của [`SoltuneMontepre/Fuvekonse`](https://github.com/SoltuneMontepre/Fuvekonse), cung cấp:
- Link commit (hoặc diff) trên nhánh `backend/<ten-van-de>`
- File proposal đã điền đầy đủ
- Mô tả ngắn gọn lý do thay đổi

> [!CAUTION]
> **Không merge nhánh `backend/*` vào `main` của FuveKonMobile** cho đến khi maintainer backend xác nhận đã cherry-pick thay đổi lên repo gốc.
> Sau khi được merge vào backend gốc, chạy `task backend:subtree-pull` để đồng bộ lại.


---

## Getting Started (Flutter)

Đây là project Flutter cơ bản. Một số tài nguyên hữu ích:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

Xem tài liệu đầy đủ tại [flutter.dev](https://docs.flutter.dev/) để biết thêm về tutorials, samples, và API reference.
