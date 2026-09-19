import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  SharedPreferences? _prefs;
  static const String _keyToken = 'auth_token';

  Future<TokenStorage> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? get token => _prefs?.getString(_keyToken);

  bool get hasToken => (token ?? '').isNotEmpty;

  Future<void> save(String token) async {
    await _prefs?.setString(_keyToken, token);
  }

  Future<void> clear() async {
    await _prefs?.remove(_keyToken);
  }
}