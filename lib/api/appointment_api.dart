import 'dart:convert';

import 'package:nars/constants.dart';
import 'package:nars/models/appointment/appointment_count.dart';
import 'package:nars/models/appointment/appointment_detail.dart';
import 'package:nars/models/appointment/add_appointment_param.dart';
import 'package:nars/models/appointment/add_appointment_response.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/appointment/delete_doctor_appointment_param.dart';
import 'package:nars/models/appointment/get_appointment_by_patient_id_param.dart';
import 'package:nars/models/appointment/get_appointment_by_patient_id_response.dart';
import 'package:nars/models/appointment/get_appointment_by_practitioner_id_param.dart';
import 'package:nars/models/appointment/get_appointments_param.dart';
import 'package:nars/models/appointment/get_practitioner_appointments_count_param.dart';
import 'package:nars/models/appointment/resched_appointment_param.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class AppointmentApi {
  static Future<http.Response> addAppointment(AddAppointmentParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Appointment/AddAppointment',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: addAppointmentParamToJson(
        param,
      ),
    );

    return response;

    // return response;

    // if (response.statusCode == 200) {
    //   return AddDoctorAppointmentResponse.fromJson(jsonDecode(response.body));
    // } else {
    //   return response.body;
    // }
  }

  static Future<List<Appointment>> getPatientAppointments(
      GetAppointmentByPatientIdParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Appointment/GetAppointmentByPatientId',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: getAppointmentByPatientIdParamToJson(
        param,
      ),
    );

    if (response.statusCode == 200) {
      return GetAppointmentsResponse.fromJson(jsonDecode(response.body))
          .results;
    } else {
      print('GetAppointmentByPatientId Error:');
      print(response.body);
      throw Exception('Request API Error');
    }
  }

  static Future<List<Appointment>> getPractitionerAppointments(
      GetAppointmentByPractitionerIdParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Appointment/GetAppointmentByPractitionerId',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: getAppointmentByPractitionerIdParamToJson(
        param,
      ),
    );
    print('GetAppointmentByPractitionerId Response:');
    print(response.body);
    if (response.statusCode == 200) {
      return GetAppointmentsResponse.fromJson(jsonDecode(response.body))
          .results;
    } else {
      print('GetAppointmentByPractitionerId Error:');
      print(response.body);
      throw Exception(response.body);
    }
  }

  static Future<List<Appointment>> getAppointments(
      GetAppointmentsParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Appointment/GetAppointments',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: getAppointmentsParamToJson(
        param,
      ),
    );

    if (response.statusCode == 200) {
      return GetAppointmentsResponse.fromJson(jsonDecode(response.body))
          .results;
    } else {
      print('GetAppointmentByPractitionerId Error:');
      print(response.body);
      throw Exception(response.body);
    }
  }

  static Future<Appointment> getAppointmentById(int appointmentId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/GetAppointmentById/$appointmentId',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );
      return appointmentFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> approveAppointment(int appointmentId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/ApproveAppointment/$appointmentId',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> completeAppointment(int appointmentId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/MarkAppointmentAsCompleted/$appointmentId',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> addAppointmentDetail(
      AppointmentDetail param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/AddAppointmentDetail',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: appointmentDetailToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> editAppointmentDetail(
      AppointmentDetail param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/EditAppointmentDetail',
      );
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: appointmentDetailToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> deleteDoctorAppointment(
      DeleteDoctorAppointmentParam param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/DeleteDoctorAppointment',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: deleteDoctorAppointmentParamToJson(param),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> reschedAppointment(
      ReschedAppointmentParam param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/RescheduleAppointment',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: reschedAppointmentParamToJson(param),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<AppointmentCount>> getPractitionerAppointmentsCount(
      GetPractitionerAppointmentsCountParam param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Appointment/GetPractitionerAppointmentsCountByPractitionerId',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: getPractitionerAppointmentsCountParamToJson(param),
      );
      return appointmentsCountFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
