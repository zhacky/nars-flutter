import 'dart:convert';

Service serviceFromJson(String str) => Service.fromJson(json.decode(str));

String serviceToJson(Service data) => json.encode(data.toJson());

class Service {
  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.practitionerServices,
    required this.isDeleted,
    this.isSelected = false,
    required this.createdDate,
    required this.imageLink,
  });

  int id;
  String name;
  String description;
  dynamic practitionerServices;
  bool isDeleted;
  bool isSelected;
  DateTime createdDate;
  String imageLink;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        practitionerServices: json["practitionerServices"],
        isDeleted: json["isDeleted"],
        createdDate: DateTime.parse(json["createdDate"]),
        imageLink: json["imageLink"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "practitionerServices": practitionerServices,
        "isDeleted": isDeleted,
        "createdDate": createdDate.toIso8601String(),
        "imageLink": imageLink,
      };
}
