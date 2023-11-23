import 'dart:convert';

List<Province> provincesFromJson(String str) =>
    List<Province>.from(json.decode(str).map((x) => Province.fromJson(x)));

Province provinceFromJson(String str) => Province.fromJson(json.decode(str));

String provinceToJson(Province data) => json.encode(data.toJson());

class Province {
  Province({
    required this.id,
    required this.code,
    required this.name,
    required this.regionCode,
  });

  int id;
  String code;
  String name;
  String regionCode;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        regionCode: json["regionCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "regionCode": regionCode,
      };
}
