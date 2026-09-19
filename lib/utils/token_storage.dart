import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  SharedPreferences? _prefs;

  Future<TokenStorage> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? get token {
    final value = _prefs?.getString(accessTokenKey);
    return value == null || value.trim().isEmpty ? null : value.trim();
  }

  String? get refreshToken {
    final value = _prefs?.getString(refreshTokenKey);
    return value == null || value.trim().isEmpty ? null : value.trim();
  }

  bool get hasToken => token != null;

  Future<void> save({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _prefs?.setString(accessTokenKey, accessToken.trim());
    if (refreshToken != null && refreshToken.trim().isNotEmpty) {
      await _prefs?.setString(refreshTokenKey, refreshToken.trim());
    }
  }

  Future<void> clear() async {
    await _prefs?.remove(accessTokenKey);
    await _prefs?.remove(refreshTokenKey);
    await _prefs?.remove('auth_token');
  }
}
