import 'dart:convert';

import 'package:nars/constants.dart';
import 'package:http/http.dart' as http;

class OtpApi {
  static Future sendOtp(String phoneNumber, bool isRegistration) async {
    var userDataUri = Uri.https(
      omni_url,
      '/api/SMS/SendOTP',
    );
    final response = await http.post(
      userDataUri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Charset': 'utf-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'phoneNumber': phoneNumber,
          'isRegistration': isRegistration,
        },
      ),
    );
    return response;
  }
}
