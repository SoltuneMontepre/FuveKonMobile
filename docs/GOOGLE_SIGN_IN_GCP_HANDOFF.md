# Hand-off: Google Sign-In cho FuveKonMobile (Google Cloud Console)

> **Đối tượng:** Người quản trị Google Cloud / Firebase của dự án Fuvekon.  
> **Người giao:** Team mobile FuveKonMobile.  
> **Mục tiêu:** Bật đăng nhập Google trên app Flutter Android (và đồng bộ với backend).

---

## 1. Tóm tắt luồng

```
App (Flutter)                    Backend (general-service)
─────────────────                ─────────────────────────
GoogleSignIn.authenticate()
  → Google ID token (JWT)
  → POST /auth/google { credential }
                                 → idtoken.Validate(credential, GOOGLE_CLIENT_ID)
                                 → tạo/link user → JWT app
```

- App mobile gửi **Google ID token** (không phải access token OAuth thông thường).
- Backend xác thực token bằng **`GOOGLE_CLIENT_ID` loại Web application** (cùng client ID với Fuvekon web).
- Trên **Android**, Google bắt buộc thêm **OAuth client loại Android** (package + SHA-1) để Credential Manager cấp ID token.

---

## 2. Checklist trên Google Cloud Console

Vào: [APIs & Services → Credentials](https://console.cloud.google.com/apis/credentials)  
(Dùng **cùng GCP project** với Fuvekon web / backend production.)

### 2.1 OAuth consent screen

- [ ] Consent screen đã publish hoặc ở chế độ Testing với test users (email dev/QA).
- [ ] Scopes tối thiểu: `email`, `profile`, `openid` (Google Sign-In mặc định).

### 2.2 OAuth client — Web application (đã có sẵn cho Fuvekon web)

- [ ] Xác nhận **Client ID** loại **Web application** trùng:
  - Biến `NEXT_PUBLIC_GOOGLE_CLIENT_ID` trên Fuvekon web
  - Biến `GOOGLE_CLIENT_ID` trong mobile `.env`
  - Biến `GOOGLE_CLIENT_ID` trên backend (`Fuvekonse` — Doppler / Lambda env)

> **Quan trọng:** Mobile Android dùng Web client ID làm `serverClientId` khi lấy ID token. **Không** dùng Android client ID làm `GOOGLE_CLIENT_ID`.

### 2.3 OAuth client — Android (cần tạo hoặc cập nhật)

Tạo **OAuth 2.0 Client ID → Android** với:

| Trường | Giá trị |
|--------|---------|
| **Package name** | `com.example.fuvekonmobile` |
| **SHA-1 certificate fingerprint** | Xem mục 3 bên dưới |

- [ ] Client nằm **cùng GCP project** với Web client ở 2.2.
- [ ] Có thể đăng ký **nhiều SHA-1** trên một Android client (Google cho phép).

### 2.4 Backend

- [ ] `GOOGLE_CLIENT_ID` trên **general-service** (staging + production) = Web client ID ở 2.2.
- [ ] Không cần `GOOGLE_CLIENT_SECRET` cho luồng mobile ID token (chỉ validate JWT phía server).

Tham chiếu infra: `Fuvekonse/infras/doppler.tf` (`google_client_id`).

---

## 3. SHA-1 cần đăng ký

Android chỉ chấp nhận sign-in nếu APK được ký bằng keystore có SHA-1 **đã khai báo**.

### 3.1 Hiện trạng (dev)

Mỗi máy dev có **debug keystore riêng** → SHA-1 khác nhau. Ví dụ đã gặp:

| Môi trường | SHA-1 (ví dụ) |
|------------|----------------|
| PC dev A | `58:7E:20:1D:B1:05:01:57:C1:03:2A:8C:B8:79:0B:2E:79:7B:46:70` |
| PC / Firebase khác | `30:04:A2:73:24:49:C6:A6:7E:8C:70:87:27:C0:1D:8D:04:CD:7C:82` |

**Khuyến nghị ngắn hạn:** Thêm **tất cả SHA-1** mà team đang dùng để chạy `flutter run`.

**Khuyến nghị lâu dài (mục 5):** Chuyển sang **một shared debug keystore** + **một upload keystore production** → chỉ duy trì **2–3 SHA-1 cố định**, không cộng dồn theo từng laptop.

### 3.2 Lấy SHA-1 mới (mobile team)

```powershell
task android:google-signin-info
```

Hoặc:

```powershell
cd android
.\gradlew.bat :app:signingReport
```

Gửi dòng `SHA1:` (variant **debug**) cho admin GCP khi có máy dev mới — **cho đến khi** team triển khai shared keystore.

---

## 4. Xác minh sau khi cấu hình

Mobile team sẽ:

1. `.env` có `GOOGLE_CLIENT_ID=<Web client ID>`.
2. Stop + `flutter run` lại (hot reload không load `.env`).
3. Login → **Đăng nhập với Google** trên Android emulator/thiết bị có Google account.

**Thành công khi:**

- User chọn được tài khoản Google.
- Log app có `POST .../auth/google` → **200**.
- User vào được màn hình sau login.

**Thất bại thường gặp:**

| Triệu chứng | Nguyên nhân GCP / config |
|-------------|---------------------------|
| SnackBar lỗi OAuth Android ngay khi bấm nút | Thiếu/sai SHA-1 hoặc sai package trên Android client |
| Logcat: `CredManProvService: GetCredentialResponse error` | Cùng nguyên nhân trên |
| Không có `POST /auth/google` | Lỗi native Google — chưa tới backend |
| `POST /auth/google` → 401 `invalidGoogleToken` | Web client ID app ≠ client ID backend, hoặc token từ project GCP khác |
| Đăng nhập OK web, fail mobile | Thiếu Android OAuth client (web chỉ cần Web client) |

---

## 5. Lộ trình production (đề xuất cho admin + mobile)

| Giai đoạn | Việc trên GCP | Ghi chú |
|-----------|---------------|---------|
| **Dev ổn định** | 1 Android client + shared debug SHA-1 | Team dùng chung `debug.keystore` |
| **Internal / QA** | Thêm SHA-1 **upload key** (release keystore CI) | APK/AAB từ pipeline |
| **Play Store** | Thêm SHA-1 **App signing certificate** (Play Console) | Sau khi bật Play App Signing |

Đồng thời mobile sẽ:

- Đổi `applicationId` từ `com.example.fuvekonmobile` sang ID production (vd. `vn.fuve.fuvekon`).
- Tạo **Android OAuth client mới** cho package production (admin GCP).
- Cấu hình release signing (không dùng debug keystore cho release).

---

## 6. Tài liệu liên quan trong repo

| File | Nội dung |
|------|----------|
| [`docs/GOOGLE_SIGN_IN_ANDROID.md`](GOOGLE_SIGN_IN_ANDROID.md) | Hướng dẫn ngắn cho dev mobile |
| [`README.md`](../README.md) | Quick start + link Google Sign-In |
| [`android/app/build.gradle.kts`](../android/app/build.gradle.kts) | Sync `GOOGLE_CLIENT_ID` → `default_web_client_id` |
| [`lib/shared/services/google_sign_in_service.dart`](../lib/shared/services/google_sign_in_service.dart) | Native Google Sign-In |
| [`Fuvekonse/services/general-service/internal/services/auth_service.go`](../Fuvekonse/services/general-service/internal/services/auth_service.go) | `GoogleLoginOrRegister` + validate token |

---

## 7. Thông tin cần xác nhận với admin (copy checklist)

```
[ ] GCP project name / ID: _______________________
[ ] Web OAuth Client ID (GOOGLE_CLIENT_ID): _______________________
[ ] Android OAuth client đã tạo cho com.example.fuvekonmobile
[ ] SHA-1 đã thêm: _______________________ (và các SHA-1 dev khác nếu cần)
[ ] Backend staging GOOGLE_CLIENT_ID khớp Web client
[ ] Backend production GOOGLE_CLIENT_ID khớp Web client
[ ] OAuth consent screen: test users / published
[ ] Mobile team đã verify POST /auth/google 200
```

---

## 8. Liên hệ

Mobile team cung cấp SHA-1 mới qua `task android:google-signin-info` hoặc output `signingReport`.  
Admin GCP cập nhật Android OAuth client và xác nhận lại mục 7.
