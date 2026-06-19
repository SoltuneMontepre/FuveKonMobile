plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun readDotEnv(key: String): String? {
    val envFile = rootProject.file("../.env")
    if (!envFile.exists()) return null
    return envFile.readLines()
        .map { it.trim() }
        .firstOrNull { line ->
            line.isNotEmpty() &&
                !line.startsWith("#") &&
                line.startsWith("$key=")
        }
        ?.substringAfter("=", "")
        ?.trim()
        ?.takeIf { it.isNotEmpty() }
}

val googleWebClientId = readDotEnv("GOOGLE_CLIENT_ID")

android {
    namespace = "com.example.fuvekonmobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.fuvekonmobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // google_sign_in_android reads this when serverClientId is unset at the native layer.
        if (googleWebClientId != null) {
            resValue("string", "default_web_client_id", googleWebClientId)
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
