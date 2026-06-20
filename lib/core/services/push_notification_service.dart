import 'dart:io';



import 'package:device_info_plus/device_info_plus.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:fuvekonmobile/core/api/device_api.dart';

import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/app_router.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_unread_cubit.dart';

import 'package:fuvekonmobile/shared/services/token_storage.dart';

import 'package:logger/logger.dart';



/// Registers FCM tokens with the backend and handles incoming push notifications.

class PushNotificationService {

  PushNotificationService({

    required DeviceApi deviceApi,

    required TokenStorage tokenStorage,

    required AppRouter appRouter,

    Logger? logger,

  })  : _deviceApi = deviceApi,

        _tokenStorage = tokenStorage,

        _appRouter = appRouter,

        _logger = logger ?? Logger();



  static const _androidChannelId = 'fuvekon_notifications';

  static const _androidChannelName = 'Fuvekon Notifications';



  final DeviceApi _deviceApi;

  final TokenStorage _tokenStorage;

  final AppRouter _appRouter;

  final Logger _logger;

  final FlutterLocalNotificationsPlugin _localNotifications =

      FlutterLocalNotificationsPlugin();



  bool _initialized = false;

  String? _currentToken;

  String? _pendingNotificationId;



  bool get isSupported =>

      !kIsWeb &&

      (defaultTargetPlatform == TargetPlatform.android ||

          defaultTargetPlatform == TargetPlatform.iOS);



  /// Initializes Firebase and notification listeners. Safe to call on all platforms.

  Future<void> initialize() async {

    if (!isSupported || _initialized) return;



    try {

      await Firebase.initializeApp();

      await _initLocalNotifications();

      await _requestPermission();

      await _configureForegroundPresentation();



      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpened);

      FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh);



      _initialized = true;



      final initialMessage =

          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {

        _storePendingNavigation(initialMessage.data);

      }



      _logger.i('Push notifications initialized');

    } on Object catch (error, stackTrace) {

      _logger.w(

        'Push notifications disabled — see docs/FCM_SETUP.md',

        error: error,

        stackTrace: stackTrace,

      );

    }

  }



  /// Registers the device token when the user has a valid session.

  Future<void> registerTokenIfAuthenticated() async {

    if (!_initialized) return;



    final accessToken = await _tokenStorage.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) return;



    try {

      final token = await FirebaseMessaging.instance.getToken();

      if (token == null || token.isEmpty) return;



      await _registerToken(token);

      await _flushPendingNavigation();

    } on Object catch (error, stackTrace) {

      _logger.w(

        'FCM token registration failed',

        error: error,

        stackTrace: stackTrace,

      );

    }

  }



  /// Removes the device token from the backend (call on logout).

  Future<void> unregisterToken() async {

    if (!_initialized) return;



    final token = _currentToken ?? await FirebaseMessaging.instance.getToken();

    if (token != null && token.isNotEmpty) {

      await _deviceApi.unregisterFcmToken(token: token);

    }



    _currentToken = null;

    try {

      await FirebaseMessaging.instance.deleteToken();

    } on Object catch (_) {

      // Best-effort cleanup.

    }

  }



  Future<void> _initLocalNotifications() async {

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(

      android: androidSettings,

      iOS: iosSettings,

    );



    await _localNotifications.initialize(

      settings: settings,

      onDidReceiveNotificationResponse: (response) {

        final payload = response.payload;

        if (payload != null && payload.isNotEmpty) {

          _navigateToNotification(payload);

        }

      },

    );



    if (Platform.isAndroid) {

      await _localNotifications

          .resolvePlatformSpecificImplementation<

              AndroidFlutterLocalNotificationsPlugin>()

          ?.createNotificationChannel(

            const AndroidNotificationChannel(

              _androidChannelId,

              _androidChannelName,

              importance: Importance.high,

            ),

          );

    }

  }



  Future<void> _requestPermission() async {

    if (Platform.isAndroid) {

      await _localNotifications

          .resolvePlatformSpecificImplementation<

              AndroidFlutterLocalNotificationsPlugin>()

          ?.requestNotificationsPermission();

      return;

    }



    final settings = await FirebaseMessaging.instance.requestPermission(

      alert: true,

      badge: true,

      sound: true,

    );



    if (settings.authorizationStatus == AuthorizationStatus.denied) {

      _logger.i('Push notification permission denied');

    }

  }



  Future<void> _configureForegroundPresentation() async {

    if (defaultTargetPlatform == TargetPlatform.iOS) {

      await FirebaseMessaging.instance

          .setForegroundNotificationPresentationOptions(

        alert: true,

        badge: true,

        sound: true,

      );

    }

  }



  Future<void> _onTokenRefresh(String token) async {

    _currentToken = token;

    final accessToken = await _tokenStorage.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) return;

    await _registerToken(token);

  }



  Future<void> _registerToken(String token) async {

    final platform = _platformName();

    if (platform == null) return;



    await _deviceApi.registerFcmToken(

      token: token,

      platform: platform,

      deviceId: await _deviceId(),

    );

    _currentToken = token;

    _logger.i('FCM token registered ($platform)');

  }



  void _onForegroundMessage(RemoteMessage message) {

    final notification = message.notification;

    if (notification == null) return;



    final notificationId = message.data['notification_id'];

    _showLocalNotification(
      title: notification.title ?? 'Fuvekon',
      body: notification.body ?? '',
      payload: notificationId is String ? notificationId : null,
    );

    try {
      sl<NotificationUnreadCubit>().refresh();
    } catch (_) {}
  }



  void _onNotificationOpened(RemoteMessage message) {

    _navigateFromData(message.data);

  }



  Future<void> _showLocalNotification({

    required String title,

    required String body,

    String? payload,

  }) async {

    const androidDetails = AndroidNotificationDetails(

      _androidChannelId,

      _androidChannelName,

      importance: Importance.high,

      priority: Priority.high,

    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(

      android: androidDetails,

      iOS: iosDetails,

    );



    await _localNotifications.show(

      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),

      title: title,

      body: body,

      notificationDetails: details,

      payload: payload,

    );

  }



  void _storePendingNavigation(Map<String, dynamic> data) {

    final id = data['notification_id'];

    if (id is String && id.isNotEmpty) {

      _pendingNotificationId = id;

    }

  }



  Future<void> _flushPendingNavigation() async {

    final id = _pendingNotificationId;

    if (id == null) return;

    _pendingNotificationId = null;

    _navigateToNotification(id);

  }



  void _navigateFromData(Map<String, dynamic> data) {

    final id = data['notification_id'];

    if (id is! String || id.isEmpty) return;

    _navigateToNotification(id);

  }



  void _navigateToNotification(String notificationId) {

    _tokenStorage.getAccessToken().then((token) {

      if (token == null || token.isEmpty) {

        _pendingNotificationId = notificationId;

        return;

      }

      final route = Routes.accountNotificationDetail(notificationId);

      final router = _appRouter.router;

      if (router.state.matchedLocation != route) {

        router.go(route);

      }

    });

  }



  String? _platformName() {

    if (defaultTargetPlatform == TargetPlatform.android) return 'android';

    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ios';

    return null;

  }



  Future<String?> _deviceId() async {

    final plugin = DeviceInfoPlugin();

    try {

      if (Platform.isAndroid) {

        final info = await plugin.androidInfo;

        return info.id;

      }

      if (Platform.isIOS) {

        final info = await plugin.iosInfo;

        return info.identifierForVendor;

      }

    } on Object catch (_) {

      return null;

    }

    return null;

  }

}


