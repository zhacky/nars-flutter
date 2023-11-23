import 'dart:async';

import 'package:nars/constants.dart';
import 'package:nars/models/address/addressAlls.dart';
import 'package:nars/models/address/barangay.dart';
import 'package:nars/models/address/set_default_adress_param.dart';
import 'package:nars/models/patient/get_profile.dart';
import 'package:nars/models/address/province.dart';
import 'package:nars/models/address/region.dart';
import 'package:nars/models/address/town.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class AddressApi {
  static Future<List<Region>> getRegions() async {
    var uri = Uri.https(
      omni_url,
      '/api/Address/GetRegions',
    );
    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      return regionsFromJson(response.body);
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<List<Province>> getProvincesByRegionCode(
      String regionCode) async {
    var uri = Uri.https(
      omni_url,
      '/api/Address/GetProvincesByRegionCode/$regionCode',
    );
    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      return provincesFromJson(response.body);
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<List<Town>> getTownsByProvinceCode(
      String regionCode, String provinceCode) async {
    var uri = Uri.https(
      omni_url,
      '/api/Address/GetTownsByProvinceCode/$regionCode/$provinceCode',
    );
    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      return townsFromJson(response.body);
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<List<Barangay>> getBarangaysByTownCode(String townCode) async {
    var uri = Uri.https(
      omni_url,
      '/api/Address/GetBarangaysByTownCode/$townCode',
    );
    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      return barangaysFromJson(response.body);
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<List<AddressAll>> getAddresses(int patientId) async {
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
      return getProfileResponseFromJson(response.body).information.addressAlls!;
    } else {
      throw Exception('Request API Error');
    }
  }

  static Future<http.Response> setDefaultAddress(
      SetDefaultAddressParam param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Address/PatientSetDefaultAddress',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: setDefaultAddressParamToJson(param),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
