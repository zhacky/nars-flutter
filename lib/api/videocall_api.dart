import 'package:nars/constants.dart';
import 'package:nars/models/videocall/join_video_call_param.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class VideoCallApi {
  static Future<http.Response> joinVideoCall(JoinVideoCallParam param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/JoinVideoCall',
      );
      final response = await http.post(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: joinVideoCallParamToJson(
          param,
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
