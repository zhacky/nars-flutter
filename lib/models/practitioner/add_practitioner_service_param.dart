import 'dart:convert';

AddPractitionerServiceParam addPractitionerServiceParamFromJson(String str) =>
    AddPractitionerServiceParam.fromJson(json.decode(str));

String addPractitionerServiceParamToJson(AddPractitionerServiceParam data) =>
    json.encode(data.toJson());

class AddPractitionerServiceParam {
  AddPractitionerServiceParam({
    required this.serviceIds,
  });

  List<int> serviceIds;

  factory AddPractitionerServiceParam.fromJson(Map<String, dynamic> json) =>
      AddPractitionerServiceParam(
        serviceIds: List<int>.from(json["serviceIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "serviceIds": List<dynamic>.from(serviceIds.map((x) => x)),
      };
}
