import 'package:fuvekonmobile/shared/services/token_storage.dart';

/// Fuvekon web uses cookie sessions; there is no `/auth/refresh` on the general API.
/// Refresh is a no-op unless the backend adds a refresh endpoint and issues refresh tokens.
class TokenRefreshService {
  TokenRefreshService({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;

  Future<String?> refresh() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }
    // No refresh endpoint in Fuvekon general API — caller should re-login.
    return null;
  }
}
