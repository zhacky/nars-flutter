import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:nars/constants.dart';
import 'package:nars/models/practitioner/add_practitioner_service_param.dart';
import 'package:nars/models/practitioner/add_practitioner_specializations_param.dart';
import 'package:nars/models/practitioner/edit_consultation_settings_param.dart';
import 'package:nars/models/practitioner/edit_practitioner_param.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:nars/models/practitioner/get_practitioners_param.dart';
import 'package:nars/models/practitioner/get_practitioners_response.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PractitionerApi {
  static Future<List<Practitioner>> getPractitioners(
      GetPractitionersParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Practitioner/GetPractitioners',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: getPractitionersParamToJson(param),
    );

    if (response.statusCode == 200) {
      return GetPractitionersResponse.fromJson(jsonDecode(response.body))
          .results;
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<Practitioner> getPractitioner(int id) async {
    var uri = Uri.https(
      omni_url,
      '/api/Practitioner/GetPractitionerById/$id',
    );
    final response = await http.get(
      uri,
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      // body: getPractitionersParamToJson(param),
    );

    if (response.statusCode == 200) {
      return Practitioner.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<http.Response> editPractitionerSpecializations(
      PractitionerAddSpecializationsParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/PractitionerSpeciality/AddPractitionerSpeciality',
    );
    try {
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: practitionerAddSpecializationsParamToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> editPractitionerServices(
      AddPractitionerServiceParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/PractitionerService/PractitionerAddService',
    );
    try {
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: addPractitionerServiceParamToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> editPractitioner(
      EditPractitionerProfileParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Practitioner/EditPractitionerProfile',
    );
    try {
      var response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: editPractitionerProfileParamToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> editConsultationSettings(
      EditConsultationSettingsParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Practitioner/EditPractitionerProfile',
    );
    try {
      var response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: editConsultationSettingsParamToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> practitionerUploadProfilePicture(File image) async {
    final dio = Dio();
    try {
      FormData formData = FormData.fromMap({
        "formFile": await MultipartFile.fromFile(
          image.path,
          contentType: MediaType('image', 'jpg'),
        ),
        "type": "image/jpg"
      });
      var response = await dio.post(
          'https://$omni_url/api/Practitioner/PractitionerUploadProfilePicture',
          data: formData,
          options: Options(headers: {
            'Authorization': 'Bearer ' + TokenPreferences.getToken()!
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> practitionerUploadSignature(File image) async {
    final dio = Dio();
    try {
      FormData formData = FormData.fromMap({
        "formFile": await MultipartFile.fromFile(
          image.path,
          contentType: MediaType('image', 'jpg'),
        ),
        "type": "image/jpg"
      });
      var response = await dio.post(
          'https://$omni_url/api/Practitioner/PractitionerUploadSignature',
          data: formData,
          options: Options(headers: {
            'Authorization': 'Bearer ' + TokenPreferences.getToken()!
          }));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

// class PractitionerManager {
//   final StreamController<int> _practitionerCount = StreamController<int>();
//   Stream<int> get practitionerCount => _practitionerCount.stream;

//   Stream<List<Practitioner>> get practitionerListView async* {
//     yield await PractitionerApi.getPractitioners(
//       GetPractitionersParam(
//         pageCommon: PageCommon(
//           page: 1,
//           pageSize: 100,
//         ),
//         userType: 2,
//       ),
//     );
//   }

//   ProfileManager() {
//     practitionerListView.listen((list) => _practitionerCount.add(list.length));
//   }
// }
