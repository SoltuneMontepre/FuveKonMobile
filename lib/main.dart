import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fuvekonmobile/app.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/services/firebase_messaging_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Background handler spins up a second FlutterEngine on Android (~200MB+).
  // Skip in debug to avoid OOM kills on low-RAM emulators; release keeps full FCM.
  if (kReleaseMode &&
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  await AppConfig.load();
  await configureDependencies();
  runApp(const FuvekonApp());
}
