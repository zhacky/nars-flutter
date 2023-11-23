import 'package:nars/constants.dart';
import 'package:nars/models/system_profile/system_profile.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class SystemProfileApi {
  static Future<SystemProfile> getSystemProfile() async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/SystemProfile/GetSystemProfileById/1',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );
      return systemProfileFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
