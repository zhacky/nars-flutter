import 'package:nars/constants.dart';
import 'package:nars/models/user/auth.dart';
import 'package:nars/models/user/user_registration.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<http.Response> register(UserRegistrationParam param) async {
    print(userRegistrationParamToJson(param));
    var uri = Uri.https(
      omni_url,
      '/api/User/UserRegistration',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: userRegistrationParamToJson(
        param,
      ),
    );

    return response;

    // if (response.statusCode == 200) {
    //   return response;
    // } else {
    //   return response.body;
    // }
  }

  static Future<Auth> getUserData() async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Authentication/GetUserData',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );

      return authFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
