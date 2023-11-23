import 'dart:async';
import 'dart:convert';

import 'package:nars/constants.dart';
import 'package:nars/models/practitioner/practitioner_service.dart';
import 'package:nars/models/service/get_services_response.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/models/service/service.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class ServiceApi {
  static Future<List<Service>> getServices() async {
    var uri = Uri.https(
      omni_url,
      '/api/Symptom/GetSymptoms',
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
      return GetServicesResponse.fromJson(jsonDecode(response.body)).results;
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<List<PractitionerService>> getPractitionerServices(
      int practitionerId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/PractitionerService/GetPractitionerServices/$practitionerId',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );

      return practitionerServicesFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
