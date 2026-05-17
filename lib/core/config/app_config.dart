abstract final class AppConfig {
  static const String appName = 'Fuvekon';

  /// Fuvekon web prod base: `https://api.fuve.vn/api/general/v1`
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.fuve.vn/api/general/v1',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
