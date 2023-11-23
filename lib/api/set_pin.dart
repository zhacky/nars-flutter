import 'package:nars/constants.dart';
import 'package:nars/models/user/change_pin_param.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class SetPinApi {
  static Future<http.Response> changePin(ChangePinParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Authentication/ChangePin',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json-patch+json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: changePinParamToJson(param),
    );

    return response;
  }
}
