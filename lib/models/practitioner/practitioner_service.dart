import 'dart:convert';

PractitionerService practitionerServiceFromJson(String str) =>
    PractitionerService.fromJson(json.decode(str));

String practitionerServiceToJson(PractitionerService data) =>
    json.encode(data.toJson());

List<PractitionerService> practitionerServicesFromJson(String str) =>
    List<PractitionerService>.from(
        json.decode(str).map((x) => PractitionerService.fromJson(x)));

class PractitionerService {
  PractitionerService({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
  });

  int id;
  int serviceId;
  String serviceName;
  String serviceDescription;

  factory PractitionerService.fromJson(Map<String, dynamic> json) =>
      PractitionerService(
        id: json["id"],
        serviceId: json["serviceId"],
        serviceName: json["serviceName"],
        serviceDescription: json["serviceDescription"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceId": serviceId,
        "serviceName": serviceName,
        "serviceDescription": serviceDescription,
      };
}
