import 'dart:convert';

import 'package:nars/models/pagination/pagination_param.dart';

GetPractitionersParam getPractitionersParamFromJson(String str) =>
    GetPractitionersParam.fromJson(json.decode(str));

String getPractitionersParamToJson(GetPractitionersParam data) =>
    json.encode(data.toJson());

class GetPractitionersParam {
  GetPractitionersParam({
    required this.pageCommon,
    required this.userType,
    this.status,
    this.address,
    this.hospitalId,
    this.symptomsId,
    this.specializationId,
  });

  PageCommon pageCommon;
  int userType;
  int? status;
  String? address;
  int? hospitalId;
  int? symptomsId;
  int? specializationId;

  factory GetPractitionersParam.fromJson(Map<String, dynamic> json) =>
      GetPractitionersParam(
        pageCommon: PageCommon.fromJson(json["pageCommon"]),
        userType: json["userType"],
        status: json["status"],
        address: json["address"],
        hospitalId: json["hospitalId"],
        symptomsId: json["symptomsId"],
        specializationId: json["specializationId"],
      );

  Map<String, dynamic> toJson() => {
        "pageCommon": pageCommon.toJson(),
        "userType": userType,
        "status": status,
        "address": address,
        "hospitalId": hospitalId,
        "symptomsId": symptomsId,
        "specializationId": specializationId,
      };
}
