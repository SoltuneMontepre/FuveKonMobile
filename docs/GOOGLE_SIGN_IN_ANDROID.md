# Google Sign-In trên Android (dev mobile)

Hướng dẫn ngắn cho developer. **Cấu hình Google Cloud Console** do admin xử lý — xem hand-off:

**→ [`GOOGLE_SIGN_IN_GCP_HANDOFF.md`](GOOGLE_SIGN_IN_GCP_HANDOFF.md)**

## App-side (đã cấu hình)

| Mục | Chi tiết |
|-----|----------|
| Package | `com.example.fuvekonmobile` |
| Web client ID | `GOOGLE_CLIENT_ID` trong `.env` |
| Gradle | `android/app/build.gradle.kts` sync `default_web_client_id` từ `.env` |
| Plugin | `google_sign_in` v7 + Android Credential Manager |

Sau khi đổi `.env`: **stop** và `flutter run` lại.

## Lấy SHA-1 debug (gửi admin GCP)

```powershell
task android:google-signin-info
```

## Kiểm tra nhanh

1. Login → **Đăng nhập với Google**
2. Terminal: `POST .../auth/google` → 200
3. Không còn `CredManProvService: GetCredentialResponse error` trong logcat

## Lỗi thường gặp

| Triệu chứng | Hướng xử lý |
|-------------|-------------|
| SnackBar OAuth Android | Admin thêm đúng SHA-1 + package trên GCP ([hand-off](GOOGLE_SIGN_IN_GCP_HANDOFF.md)) |
| Không có `POST /auth/google` | Lỗi native — chưa qua backend |
| `invalidGoogleToken` | `GOOGLE_CLIENT_ID` app ≠ backend |
