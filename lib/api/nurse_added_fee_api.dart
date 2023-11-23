import 'package:nars/constants.dart';
import 'package:nars/models/nurse_added_fee/nurse_added_fee.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class NurseAddedFeeApi {
  static Future<List<NurseAddedFee>> getNurseAddedFees() async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/NurseAddedFee/GetNurseAddedFees',
      );
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );
      return nurseAddedFeesFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
