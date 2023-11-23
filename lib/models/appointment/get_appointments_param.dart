import 'dart:convert';

import 'package:nars/models/pagination/pagination_param.dart';

GetAppointmentsParam getAppointmentsParamFromJson(String str) =>
    GetAppointmentsParam.fromJson(json.decode(str));

String getAppointmentsParamToJson(GetAppointmentsParam data) =>
    json.encode(data.toJson());

class GetAppointmentsParam {
  GetAppointmentsParam({
    required this.pageCommon,
    required this.isForNurse,
  });

  PageCommon pageCommon;
  bool isForNurse;

  factory GetAppointmentsParam.fromJson(Map<String, dynamic> json) =>
      GetAppointmentsParam(
        pageCommon: PageCommon.fromJson(json["pageCommon"]),
        isForNurse: json["isForNurse"],
      );

  Map<String, dynamic> toJson() => {
        "pageCommon": pageCommon.toJson(),
        "isForNurse": isForNurse,
      };
}
