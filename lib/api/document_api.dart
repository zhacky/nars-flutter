import 'dart:convert';
import 'dart:io';
import 'package:nars/constants.dart';
import 'package:nars/models/document/document.dart';
import 'package:nars/models/document/get_documents_response.dart';
import 'package:nars/models/practitioner/get_practitioner_documents_param.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class DocumentApi {
  static Future<dynamic> uploadDocument(
      File image, int type, String other) async {
    final dio = Dio();
    String filename = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "formFile": await MultipartFile.fromFile(
        image.path,
        filename: filename,
        contentType: MediaType('image', 'jpg'),
      ),
      "type": "image/jpg"
    });
    var response = await dio.post(
      'https://$omni_url/api/Practitioner/PractitionerUploadDocument?DocumentType=$type' +
          (other != '' ? '&Other=$other' : ''),
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer ' + TokenPreferences.getToken()!},
      ),
    );
    return response;
  }

  static Future<dynamic> uploadAppointmentDocument(
      File image, int appointmentId, String name) async {
    final dio = Dio();
    String filename = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "FormFile": await MultipartFile.fromFile(
        image.path,
        filename: filename,
        contentType: MediaType('image', 'jpg'),
      ),
      "AppointmentId": appointmentId,
      "Name": name,
      "type": "image/jpg"
    });
    var response = await dio.post(
      'https://$omni_url/api/Appointment/AddAppointmentDocument',
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer ' + TokenPreferences.getToken()!},
      ),
    );
    return response;
  }

  static Future<List<Document>> getPractitionerDocuments(int userId) async {
    var uri = Uri.https(
      omni_url,
      '/api/Documents/GetPractitionerDocuments',
    );
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: getPractitionerDocumentsParamToJson(
          GetPractitionerDocumentsParam(
            practitionerId: userId,
            pageCommon: PageCommon(
              page: 1,
              pageSize: 100,
            ),
          ),
        ),
      );
      return GetDocumentsResponse.fromJson(jsonDecode(response.body)).results;
    } catch (e) {
      rethrow;
      // throw Exception('Request API Error');
    }

    // if (response.statusCode == 200) {
    //   return GetDocumentsResponse.fromJson(jsonDecode(response.body)).results;
    // } else {
    //   throw Exception('Request API Error');
    // }
  }
}
