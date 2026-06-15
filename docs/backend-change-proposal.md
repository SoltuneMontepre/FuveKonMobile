# Backend Change Proposal

> Điền đầy đủ template này khi bạn (mobile developer) cần đề xuất thay đổi
> lên maintainer của repo backend gốc [`SoltuneMontepre/Fuvekonse`](https://github.com/SoltuneMontepre/Fuvekonse).
> File này phải được commit cùng với nhánh `backend/<ten-van-de>`.

---

## Thông tin cơ bản

| Trường | Nội dung |
|---|---|
| **Người đề xuất** | _(tên / GitHub handle)_ |
| **Ngày tạo** | _(YYYY-MM-DD)_ |
| **Nhánh** | `backend/<ten-van-de>` |
| **Service bị ảnh hưởng** | `general-service` / `rbac-service` / `sqs-worker` / _(khác)_ |

---

## Lý do thay đổi

> Mô tả rõ vấn đề phát sinh từ phía mobile app dẫn đến cần thay đổi backend.
> Ví dụ: "Mobile app nhận lỗi 401 sau 30 phút dù token chưa hết hạn."

_(Điền vào đây)_

---

## Phạm vi thay đổi

> Liệt kê các file đã sửa trong thư mục `Fuvekonse/`, kèm mô tả ngắn gọn từng thay đổi.

| File | Loại thay đổi | Mô tả |
|---|---|---|
| `services/general-service/...` | `fix` / `feat` / `refactor` | _(mô tả)_ |
| _(thêm dòng nếu cần)_ | | |

---

## Cách reproduce vấn đề (trước khi sửa)

```
1. 
2. 
3. 
```

---

## Cách verify sau khi sửa

> Mô tả các bước test đã thực hiện trên môi trường local.

```bash
# Môi trường test:
# - task backend:docker-up
# - task backend:migrate
# - task backend:dev

# Các bước test:
1. 
2. 
```

**Kết quả:** _(Pass / Fail + screenshot / log nếu có)_

---

## Ảnh hưởng có thể có

> Mô tả các side effect có thể xảy ra, backward compatibility, breaking change, v.v.

- [ ] Không có breaking change
- [ ] Cần migration database
- [ ] Cần thay đổi environment variable
- [ ] Ảnh hưởng đến API contract (endpoint / request / response)
- [ ] Khác: _(mô tả)_

---

## Commit reference

> Link hoặc hash của commit trên nhánh `backend/<ten-van-de>` trong repo `FuveKonMobile`.

```
Branch : backend/<ten-van-de>
Commit : <hash>
Diff   : https://github.com/<your-fork-or-local>/compare/main...backend/<ten-van-de>
```

---

## Yêu cầu với maintainer

- [ ] Review và xác nhận thay đổi hợp lý
- [ ] Cherry-pick commit này lên nhánh `main` của `SoltuneMontepre/Fuvekonse`
- [ ] Thông báo lại sau khi merge để mobile dev chạy `task backend:subtree-pull`

---

> [!NOTE]
> Sau khi maintainer xác nhận đã cherry-pick, **không merge nhánh `backend/*` vào `main` của FuveKonMobile**.
> Thay vào đó, chạy `task backend:subtree-pull` để đồng bộ thay đổi từ repo gốc.
