import 'dart:async';
import 'dart:convert';

import 'package:nars/constants.dart';
import 'package:nars/models/practitioner/practitioner_specialization.dart';
import 'package:nars/models/specialization/get_specializations_response.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/models/specialization/specialization.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class SpecializationApi {
  // static late SpecializationApi _instance;

  // SpecializationApi._();

  // static SpecializationApi get instance {
  //   if (_instance == null) {
  //     _instance = SpecializationApi._();
  //   }
  //   return _instance;
  // }

  static Future<List<Specialization>> getSpecializations() async {
    var uri = Uri.https(
      omni_url,
      '/api/Speciality/GetSpecialities',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: paginationParamToJson(
        PaginationParam(
          pageCommon: PageCommon(
            page: 1,
            pageSize: 100,
          ),
        ),
      ),
    );

    if (response.statusCode == 200) {
      return GetSpecializationsResponse.fromJson(jsonDecode(response.body))
          .results;
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<List<PractitionerSpecialization>>
      getPractitionerSpecializations(int practitionerId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/PractitionerSpeciality/GetPractitionerSpecialties/$practitionerId',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );

      return practitionerSpecializationsFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
