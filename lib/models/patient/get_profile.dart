import 'dart:convert';

import 'package:nars/models/information/information.dart';

GetProfileResponse getProfileResponseFromJson(String str) =>
    GetProfileResponse.fromJson(json.decode(str));

String getProfileResponseToJson(GetProfileResponse data) =>
    json.encode(data.toJson());

class GetProfileResponse {
  GetProfileResponse({
    required this.information,
  });

  Information information;

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) =>
      GetProfileResponse(
        information: Information.fromJson(json["information"]),
      );

  Map<String, dynamic> toJson() => {
        "information": information.toJson(),
      };
}
