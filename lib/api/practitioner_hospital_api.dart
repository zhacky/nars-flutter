import 'dart:async';
import 'dart:convert';

import 'package:nars/constants.dart';
import 'package:nars/models/practitioner/add_practitioner_hospital_schedule_param.dart';
import 'package:nars/models/practitioner/edit_practitioner_hospital_schedule_param.dart';
import 'package:nars/models/practitioner/practitioner_hospital.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class PractitionerHospitalApi {
  static Future<PractitionerHospital> getPractitionerHospital(int id) async {
    var uri = Uri.https(
      omni_url,
      '/api/PractitionerHospitalSchedule/GetPractitionerScheduleHospitalById/$id',
    );
    final response = await http.get(
      uri,
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
    );

    if (response.statusCode == 200) {
      return getPractitionerHospitalFromJson(response.body);
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<http.Response> editPractitionerHospitalSchedule(
      EditPractitionerHospitalScheduleParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/PractitionerHospitalSchedule/PractitionerEditHospitalSchedule',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: editPractitionerHospitalScheduleParamToJson(
        param,
      ),
    );

    return response;

    // if (response.statusCode == 200) {
    //   return response.body;
    // } else {
    //   return response.body;
    // }
  }

  static Future<http.Response> addPractitionerHospitalSchedule(
      AddPractitionerHospitalScheduleParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/PractitionerHospitalSchedule/PractitionerAddHospitalSchedule',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: addPractitionerHospitalScheduleParamToJson(
        param,
      ),
    );

    return response;

    // if (response.statusCode == 200) {
    //   return response.body;
    // } else {
    //   return response.body;
    // }
  }

  static Future<http.Response> deletePractitionerHospitalSchedule(
      int practitionerHospitalId) async {
    var uri = Uri.https(
      omni_url,
      '/api/PractitionerHospitalSchedule/PractitionerDeleteHospitalSchedule',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: jsonEncode(
        <String, int>{
          'practitionerHospitalId': practitionerHospitalId,
        },
      ),
    );

    return response;

    // if (response.statusCode == 200) {
    //   return response.body;
    // } else {
    //   return response.body;
    // }
  }
}
