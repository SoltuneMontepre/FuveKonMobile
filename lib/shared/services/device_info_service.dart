import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Collects stable device metadata for multi-device session tracking.
class DeviceInfoService {
  DeviceInfoService({DeviceInfoPlugin? plugin})
    : _plugin = plugin ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _plugin;

  /// Payload fields for login / Google login (`device_id`, `device_name`, `platform`).
  Future<Map<String, String>> loginDevicePayload() async {
    final platform = _platform();
    final id = await deviceId();
    final name = await deviceName();
    return {
      if (id != null && id.isNotEmpty) 'device_id': id,
      if (name != null && name.isNotEmpty) 'device_name': name,
      'platform': ?platform,
    };
  }

  String? _platform() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      default:
        return null;
    }
  }

  Future<String?> deviceId() async {
    if (kIsWeb) return null;
    try {
      if (Platform.isAndroid) {
        final info = await _plugin.androidInfo;
        return info.id;
      }
      if (Platform.isIOS) {
        final info = await _plugin.iosInfo;
        return info.identifierForVendor;
      }
      if (Platform.isWindows) {
        final info = await _plugin.windowsInfo;
        return info.deviceId;
      }
      if (Platform.isMacOS) {
        final info = await _plugin.macOsInfo;
        return info.systemGUID;
      }
      if (Platform.isLinux) {
        final info = await _plugin.linuxInfo;
        return info.machineId;
      }
    } on Object {
      return null;
    }
    return null;
  }

  Future<String?> deviceName() async {
    if (kIsWeb) return 'Web browser';
    try {
      if (Platform.isAndroid) {
        final info = await _plugin.androidInfo;
        final brand = info.brand.trim();
        final model = info.model.trim();
        if (brand.isNotEmpty && model.isNotEmpty) {
          return '$brand $model';
        }
        return model.isNotEmpty ? model : 'Android device';
      }
      if (Platform.isIOS) {
        final info = await _plugin.iosInfo;
        final name = info.name.trim();
        if (name.isNotEmpty) return name;
        final model = info.model.trim();
        return model.isNotEmpty ? model : 'iPhone';
      }
      if (Platform.isWindows) {
        final info = await _plugin.windowsInfo;
        final name = info.computerName.trim();
        return name.isNotEmpty ? name : 'Windows';
      }
      if (Platform.isMacOS) {
        final info = await _plugin.macOsInfo;
        final name = info.computerName.trim();
        return name.isNotEmpty ? name : 'Mac';
      }
      if (Platform.isLinux) {
        final info = await _plugin.linuxInfo;
        final name = info.prettyName.trim();
        return name.isNotEmpty ? name : 'Linux';
      }
    } on Object {
      return null;
    }
    return null;
  }
}
