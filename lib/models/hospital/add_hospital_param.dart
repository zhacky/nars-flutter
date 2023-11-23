import 'dart:convert';

AddHospitalParam addHospitalParamFromJson(String str) =>
    AddHospitalParam.fromJson(json.decode(str));

String addHospitalParamToJson(AddHospitalParam data) =>
    json.encode(data.toJson());

class AddHospitalParam {
  AddHospitalParam({
    required this.name,
    required this.description,
    required this.imageLink,
    required this.address,
  });

  String name;
  String description;
  String imageLink;
  Address address;

  factory AddHospitalParam.fromJson(Map<String, dynamic> json) =>
      AddHospitalParam(
        name: json["name"],
        description: json["description"],
        imageLink: json["imageLink"],
        address: Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "imageLink": imageLink,
        "address": address.toJson(),
      };
}

class Address {
  Address({
    required this.regionCode,
    required this.provinceCode,
    required this.townCode,
    required this.barangayCode,
    required this.address,
    required this.isDefault,
  });

  String regionCode;
  String provinceCode;
  String townCode;
  String barangayCode;
  String address;
  bool isDefault;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        regionCode: json["regionCode"],
        provinceCode: json["provinceCode"],
        townCode: json["townCode"],
        barangayCode: json["barangayCode"],
        address: json["address"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "regionCode": regionCode,
        "provinceCode": provinceCode,
        "townCode": townCode,
        "barangayCode": barangayCode,
        "address": address,
        "isDefault": isDefault,
      };
}
