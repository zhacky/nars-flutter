import 'package:nars/constants.dart';
import 'package:nars/models/common/link_response.dart';
import 'package:nars/models/prescription/prescription.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class PrescriptionApi {
  static Future<LinkResponse> generatePrescription(int appointmentId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Documents/Prescription/$appointmentId',
      );
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer ' + TokenPreferences.getToken()!},
      );
      return linkResponseFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Prescription>> getPrescriptions(int appointmentId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/GetPrescriptionsByAppointmentId/$appointmentId',
      );
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer ' + TokenPreferences.getToken()!},
      );
      return prescriptionsFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> addPrescription(Prescription param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/AddPrescription',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!,
        },
        body: prescriptionToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> editPrescription(Prescription param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/EditPrescription',
      );
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!,
        },
        body: prescriptionToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> deletePrescription(int prescriptionId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/DeletePrescription/$prescriptionId',
      );
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
