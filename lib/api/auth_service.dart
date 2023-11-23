import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/models/user/auth.dart';
import 'package:nars/models/patient/profile.dart';
import 'package:nars/models/user/user_token.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  Auth? currentUser;
  String? token;
  int? profileId;

  // AuthService() {
  //   print('new AuthService');
  // }

  Future getUser() async {
    token = TokenPreferences.getToken();
    if (token != null && token != '') {
      var userDataUri = Uri.https(
        omni_url,
        '/api/Authentication/GetUserData',
      );
      final response = await http.get(
        userDataUri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Charset': 'utf-8',
          'Authorization': 'bearer ' + (token ?? '')
        },
      );

      currentUser = Auth.fromJson(jsonDecode(response.body));
    }
    return Future.value(currentUser);
  }

  Future logout() {
    currentUser = null;
    notifyListeners();
    return Future.value(currentUser);
  }

  // Future createUser({
  //   required String contact,
  //   required String pinCode,
  // }) async {}

  Future loginUser({
    required Flavor flavor,
    required String phonenumber,
    required String pincode,
  }) async {
    var loginUri = Uri.https(
      omni_url,
      '/api/Authentication/Login',
    );
    final tokenReponse = await http.post(
      loginUri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'phoneNumber': phonenumber,
          'pin': pincode,
        },
      ),
    );

    // print('tokenReponse.body');
    // print(tokenReponse.body);

    if (tokenReponse.statusCode == 200) {
      var token = UserToken.fromJson(jsonDecode(tokenReponse.body)).token;
      
      var userDataUri = Uri.https(
        omni_url,
        '/api/Authentication/GetUserData',
      );
      final response = await http.get(
        userDataUri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Charset': 'utf-8',
          'Authorization': 'bearer ' + token
        },
      );
      currentUser = Auth.fromJson(jsonDecode(response.body));

      if (currentUser!.role.contains("Patient") && flavor != Flavor.Patient) {
        return 'This is not a practitioner account';
      }

      if (!currentUser!.role.contains("Patient") && flavor == Flavor.Patient) {
        return 'This is not a patient account';
      }

      if (currentUser!.role.contains("Patient")) {
        var profilesUri = Uri.https(
          omni_url,
          '/api/Patient/GetPatientsByLoggedId',
        );
        final profilesResponse = await http.get(
          profilesUri,
          headers: {'Authorization': 'bearer ' + token},
        );

        await TokenPreferences.setProfileId(
            getProfilesFromJson(profilesResponse.body).first.id);
      }

      // return Auth.fromJson(jsonDecode(response.body));
      await TokenPreferences.setToken(token);
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', phonenumber.substring(1));
      prefs.setString('id', currentUser!.id.toString());
      prefs.setString('userType', currentUser!.role.first);
      return Future.value(currentUser);
    } else {
      // return tokenReponse.body;
      currentUser = null;
      return Future.value(tokenReponse.body);
    }

    // if (result.isNotEmpty) {
    //   currentUser = result.first;
    //   notifyListeners();
    //   return Future.value(currentUser);
    // } else {
    //   currentUser = null;
    //   return Future.value(null);
    // }
  }
}
