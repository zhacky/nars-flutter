import 'package:shared_preferences/shared_preferences.dart';

class TokenPreferences {
  static SharedPreferences? _preferences;

  static const _keyToken = 'token';
  static const _keyProfileId = 'profileId';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setToken(String token) async =>
      await _preferences?.setString(_keyToken, token);

  static Future setProfileId(int profileId) async =>
      await _preferences?.setInt(_keyProfileId, profileId);

  static Future removeProfileId() async =>
      await _preferences?.remove(_keyProfileId);

  static String? getToken() => _preferences?.getString(_keyToken);

  static int? getProfileId() => _preferences?.getInt(_keyProfileId);
}
