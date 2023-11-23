import 'dart:convert';

List<Town> townsFromJson(String str) =>
    List<Town>.from(json.decode(str).map((x) => Town.fromJson(x)));

Town townFromJson(String str) => Town.fromJson(json.decode(str));

String townToJson(Town data) => json.encode(data.toJson());

class Town {
  Town({
    required this.id,
    required this.code,
    required this.name,
    required this.provinceCode,
    required this.districtCode,
    required this.regionCode,
  });

  int id;
  String code;
  String name;
  String provinceCode;
  String districtCode;
  String regionCode;

  factory Town.fromJson(Map<String, dynamic> json) => Town(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        provinceCode: json["provinceCode"],
        districtCode: json["districtCode"],
        regionCode: json["regionCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "provinceCode": provinceCode,
        "districtCode": districtCode,
        "regionCode": regionCode,
      };
}
