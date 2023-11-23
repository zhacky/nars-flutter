import 'dart:convert';

import 'package:nars/models/pagination/pagination_param.dart';

GetPractitionerDocumentsParam getPractitionerDocumentsParamFromJson(
        String str) =>
    GetPractitionerDocumentsParam.fromJson(json.decode(str));

String getPractitionerDocumentsParamToJson(
        GetPractitionerDocumentsParam data) =>
    json.encode(data.toJson());

class GetPractitionerDocumentsParam {
  GetPractitionerDocumentsParam({
    required this.practitionerId,
    required this.pageCommon,
  });

  int practitionerId;
  PageCommon pageCommon;

  factory GetPractitionerDocumentsParam.fromJson(Map<String, dynamic> json) =>
      GetPractitionerDocumentsParam(
        practitionerId: json["practitionerId"],
        pageCommon: PageCommon.fromJson(json["pageCommon"]),
      );

  Map<String, dynamic> toJson() => {
        "practitionerId": practitionerId,
        "pageCommon": pageCommon.toJson(),
      };
}
