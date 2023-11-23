import 'package:nars/constants.dart';
import 'package:nars/models/common/link_response.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class MedcertApi {
  static Future<LinkResponse> generateMedcert(int appointmentId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Documents/Medcert/$appointmentId',
      );
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer ' + TokenPreferences.getToken()!},
      );
      return linkResponseFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
