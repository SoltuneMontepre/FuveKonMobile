# FCM Push Notification Setup

This guide explains how to get Firebase / FCM credentials and connect them to **FuvekonMobile** (Flutter) and **Fuvekonse** (backend).

Push only works on **Android** and **iOS** physical devices. Windows, web, and desktop builds skip FCM automatically.

---

## What you need (two sides)

| Piece | Used by | What it is |
|---|---|---|
| `google-services.json` | Android app | Firebase Android config |
| `GoogleService-Info.plist` | iOS app | Firebase iOS config |
| Service account JSON | Backend (`general-service`) | Server key to **send** push via FCM API |

All three must come from the **same Firebase project**.

---

## Step 1 — Create a Firebase project

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Click **Add project** (or select an existing project)
3. Follow the wizard (Google Analytics optional)

---

## Step 2 — Add Android app

1. In Firebase Console → **Project settings** → **Your apps** → **Add app** → **Android**
2. **Android package name**: must match `applicationId` in `android/app/build.gradle.kts`  
   Current value: `com.example.fuvekonmobile`  
   (Change this to your production ID before release, e.g. `vn.fuve.fuvekon`.)
3. Download **`google-services.json`**
4. Place it at:

```
android/app/google-services.json
```

5. Rebuild the app: `flutter run -d <android-device>`

The Gradle plugin is applied automatically when this file exists.

---

## Step 3 — Add iOS app

1. Firebase Console → **Add app** → **iOS**
2. **Bundle ID**: must match Xcode `PRODUCT_BUNDLE_IDENTIFIER` (Runner target)
3. Download **`GoogleService-Info.plist`**
4. Place it at:

```
ios/Runner/GoogleService-Info.plist
```

5. Open `ios/Runner.xcworkspace` in Xcode:
   - Drag `GoogleService-Info.plist` into the **Runner** target if not already linked
   - **Signing & Capabilities** → **+ Capability** → **Push Notifications**
   - **Background Modes** → enable **Remote notifications**

6. **APNs key (required for iOS push)**  
   Firebase Console → **Project settings** → **Cloud Messaging** → **Apple app configuration**  
   Upload an APNs Authentication Key (.p8) from [Apple Developer](https://developer.apple.com/account/resources/authkeys/list).

---

## Step 4 — Backend service account (how the API sends push)

The backend does **not** use an "FCM API key" string. It uses a **Firebase service account JSON** with the Firebase Admin SDK.

### Generate the key

1. Firebase Console → **Project settings** → **Service accounts**
2. Click **Generate new private key**
3. Save the downloaded JSON file securely (never commit it)

### Configure `general-service`

In `Fuvekonse/services/general-service/.env` (see `.env.example`):

```env
FCM_ENABLED=true

# Option A — path to the JSON file (recommended for local dev)
FCM_SERVICE_ACCOUNT_PATH=C:/path/to/firebase-service-account.json

# Option B — inline JSON (useful for Docker/CI; escape quotes carefully)
# FCM_SERVICE_ACCOUNT_JSON={"type":"service_account",...}
```

Restart the backend. You should see in logs:

```
FCM push service enabled
```

If credentials are missing:

```
FCM push disabled: set FCM_SERVICE_ACCOUNT_JSON or FCM_SERVICE_ACCOUNT_PATH to enable push
```

---

## Step 5 — Optional: FlutterFire CLI

Instead of manually copying config files, you can run:

```powershell
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` and downloads platform config files.  
The app also works **without** `firebase_options.dart` — it reads native config files directly when you call `Firebase.initializeApp()`.

---

## How the app registers tokens

After login (or session restore), the app:

1. Gets an FCM device token from Firebase
2. Calls `POST /devices/fcm-token` with:

```json
{
  "token": "<fcm-device-token>",
  "platform": "android",
  "device_id": "<optional>"
}
```

On logout it calls `DELETE /devices/fcm-token`.

---

## Testing push

1. Start backend with FCM credentials: `task backend:dev`
2. Run on a **physical** Android/iOS device (not Windows)
3. Log in as a test user (`user@fuve.com` / `user123`)
4. Confirm token registration via Swagger: http://localhost:8085/swagger/index.html → `POST /devices/fcm-token`
5. As admin, create a notification with push enabled (admin API `send_push: true`)
6. Or use Firebase Console → **Engage** → **Messaging** → **Send test message** with the device FCM token

### Get the device token for manual testing

When running a debug build, check Flutter logs after login for:

```
FCM token registered (android)
```

Or temporarily log `FirebaseMessaging.instance.getToken()` in the app.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `Firebase init skipped` in logs | Add `google-services.json` / `GoogleService-Info.plist` |
| Backend `FCM is not configured` | Set `FCM_SERVICE_ACCOUNT_PATH` and `FCM_ENABLED=true` |
| Backend `no registered device tokens` | Log in on a real phone; check `POST /devices/fcm-token` |
| iOS no push | Upload APNs key in Firebase; enable Push capability in Xcode |
| Android 13+ no banner | Grant notification permission when prompted |
| Push works from Firebase Console but not backend | Service account must be from the same Firebase project as the app |

---

## Security notes

- Never commit `google-services.json`, `GoogleService-Info.plist`, or service account JSON to git (already in `.gitignore`)
- Rotate service account keys if leaked
- Use separate Firebase projects for dev/staging/production if possible
