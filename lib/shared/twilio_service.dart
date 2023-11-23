import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TwilioFunctionsService {
  TwilioFunctionsService._();
  static final instance = TwilioFunctionsService._();

  final http.Client client = http.Client();
  final accessTokenUrl = 'https://acrehealth-7936.twil.io/accessToken';

  Future<dynamic> createToken(String identity, String room) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
      };
      var url = Uri.parse(accessTokenUrl + '?user=' + identity + '&room=' + room);
      final response = await client.get(url, headers: header);
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      print('ResponseMap:');
      print(responseMap);
      return responseMap;
    } catch (error) {
      throw Exception([error.toString()]);
    }
  }
}
