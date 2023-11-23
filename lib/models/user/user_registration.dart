import 'dart:convert';

import 'package:nars/models/information/information.dart';
import 'package:nars/models/patient/patient_profile.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:nars/models/user/user_acount.dart';
// import 'package:nars/models/user_acount_demo.dart';

UserRegistrationParam userRegistrationParamFromJson(String str) =>
    UserRegistrationParam.fromJson(json.decode(str));

String userRegistrationParamToJson(UserRegistrationParam data) =>
    json.encode(data.toJson());

class UserRegistrationParam {
  UserRegistrationParam({
    required this.otpCode,
    required this.userType,
    required this.patientProfile,
    required this.practitionerProfile,
    required this.userAccount,
  });

  int userType;
  int otpCode;
  PatientProfile? patientProfile;
  Practitioner? practitionerProfile;
  UserAccount userAccount;

  factory UserRegistrationParam.fromJson(Map<String, dynamic> json) =>
      UserRegistrationParam(
        otpCode: json["otpCode"],
        userType: json["userType"],
        patientProfile: PatientProfile.fromJson(json["patientProfile"]),
        practitionerProfile:
            Practitioner.fromJson(json["practitionerProfile"]),
        userAccount: UserAccount.fromJson(json["userAccount"]),
      );

  Map<String, dynamic> toJson() => {
        "otpCode": otpCode,
        "userType": userType,
        "patientProfile": patientProfile?.toJson(),
        "practitionerProfile": practitionerProfile?.toJson(),
        "userAccount": userAccount.toJson(),
      };
}


