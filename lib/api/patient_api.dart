import 'dart:async';
import 'dart:io';

import 'package:nars/constants.dart';
import 'package:nars/models/patient/add_patient_profile_param.dart';
import 'package:nars/models/patient/add_patient_profile_response.dart';
import 'package:nars/models/patient/edit_patient_profile_param.dart';
import 'package:nars/models/patient/get_profile.dart';
import 'package:nars/models/information/information.dart';
import 'package:nars/models/patient/profile.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileApi {
  static Future<AddPatientProfileResponse> addPatientProfile(
      AddPatientProfileParam param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Patient/AddPatientProfile',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: addPatientProfileParamToJson(
          param,
        ),
      );

      return addPatientProfileResponseFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> editPatientProfile(
      EditPatientProfileParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Patient/EditPatientProfile',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: editPatientProfileParamToJson(
        param,
      ),
    );

    // return response;

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }

  static Future<List<Profile>> getProfiles() async {
    var uri = Uri.https(
      omni_url,
      '/api/Patient/GetPatientsByLoggedId',
    );
    final response = await http.get(
      uri,
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
    );

    if (response.statusCode == 200) {
      return getProfilesFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Information> getInformation(int patientId) async {
    var uri = Uri.https(
      omni_url,
      '/api/Patient/GetPatientById/$patientId',
    );
    final response = await http.get(
      uri,
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
    );

    if (response.statusCode == 200) {
      return getProfileResponseFromJson(response.body).information;
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<Profile> getPatientProfile(int patientId) async {
    var uri = Uri.https(
      omni_url,
      '/api/Patient/GetPatientById/$patientId',
    );
    final response = await http.get(
      uri,
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
    );

    if (response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<dynamic> patientProfileUploadProfilePicture(
      File image, int profileId) async {
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
          'https://$omni_url/api/Patient/PatientUploadProfilePicture',
          queryParameters: {'patientId': profileId},
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

class ProfileManager {
  final StreamController<int> _profileCount = StreamController<int>();
  Stream<int> get profileCount => _profileCount.stream;

  Stream<List<Profile>> get profileListView async* {
    yield await ProfileApi.getProfiles();
  }

  ProfileManager() {
    profileListView.listen((list) => _profileCount.add(list.length));
  }
}
