import 'dart:convert';

List<Barangay> barangaysFromJson(String str) =>
    List<Barangay>.from(json.decode(str).map((x) => Barangay.fromJson(x)));

Barangay barangayFromJson(String str) => Barangay.fromJson(json.decode(str));

String barangayToJson(Barangay data) => json.encode(data.toJson());

class Barangay {
  Barangay({
    required this.id,
    required this.code,
    required this.name,
    required this.townCode,
  });

  int id;
  String code;
  String name;
  String townCode;

  factory Barangay.fromJson(Map<String, dynamic> json) => Barangay(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        townCode: json["townCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "townCode": townCode,
      };
}
