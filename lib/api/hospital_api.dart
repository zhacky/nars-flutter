import 'dart:async';
import 'dart:convert';

import 'package:nars/constants.dart';
import 'package:nars/models/hospital/add_hospital_param.dart';
import 'package:nars/models/hospital/get_hospitals_response.dart';
import 'package:nars/models/hospital/hospital.dart';
import 'package:nars/models/practitioner/practitioner_hospital.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class HospitalApi {
  static Future<List<Hospital>> getHospitals() async {
    var uri = Uri.https(
      omni_url,
      '/api/Hospital/GetHospitals',
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
      return GetHospitalsResponse.fromJson(jsonDecode(response.body)).results;
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<http.Response> addHospital(AddHospitalParam param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Hospital/AddHospital',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!,
        },
        body: addHospitalParamToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // static Future<List<PractitionerHospital>> getHospitals2() async {
  //   var uri = Uri.https(
  //     omni_url,
  //     '/api/Address/GetRegions',
  //   );
  //   final response = await http.get(
  //     uri,
  //   );

  //   if (response.statusCode == 200) {
  //     return regionsFromJson(response.body);
  //   } else {
  //     throw Exception('Request API Error');
  //   }
  // }

  static Future<List<PractitionerHospital>> getPractitionerHospitals(
      int practitionerId) async {
    var uri = Uri.https(
      omni_url,
      '/api/PractitionerHospitalSchedule/GetPractitionerScheduleHospitals/$practitionerId',
    );
    final response = await http.get(
      uri,
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
    );

    if (response.statusCode == 200) {
      return getPractitionerHospitalsFromJson(response.body);
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<List<PractitionerHospital>> getPractitionerHospitalsWithDay(
      int practitionerId, String day) async {
    var uri = Uri.https(
      omni_url,
      '/api/PractitionerHospitalSchedule/GetPractitionerScheduleHospitals/$practitionerId/$day',
    );
    final response = await http.get(
      uri,
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
    );

    if (response.statusCode == 200) {
      return getPractitionerHospitalsFromJson(response.body);
    } else {
      throw Exception('Request API Error');
    }
  }
}
