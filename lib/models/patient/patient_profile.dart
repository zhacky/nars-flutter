import 'package:nars/models/information/information.dart';

class PatientProfile {
  PatientProfile({
    required this.information,
  });

  Information information;

  factory PatientProfile.fromJson(Map<String, dynamic> json) => PatientProfile(
        information: Information.fromJson(json["information"]),
      );

  Map<String, dynamic> toJson() => {
        "information": information.toJson(),
      };
}
