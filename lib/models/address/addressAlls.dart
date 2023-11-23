import 'dart:convert';

String addressAllToJson(AddressAll data) => json.encode(data.toJson());

class AddressAll {
  AddressAll({
    this.id,
    this.regionCode,
    this.regionName,
    this.provinceCode,
    this.provinceName,
    this.townCode,
    this.townName,
    this.barangayCode,
    this.barangayName,
    this.address,
    this.isDefault,
  });

  int? id;
  String? regionCode;
  String? regionName;
  String? provinceCode;
  String? provinceName;
  String? townCode;
  String? townName;
  String? barangayCode;
  String? barangayName;
  String? address;
  bool? isDefault;

  factory AddressAll.fromJson(Map<String, dynamic> json) => AddressAll(
        id: json["id"],
        regionCode: json["regionCode"],
        regionName: json["regionName"],
        provinceCode: json["provinceCode"],
        provinceName: json["provinceName"],
        townCode: json["townCode"],
        townName: json["townName"],
        barangayCode: json["barangayCode"],
        barangayName: json["barangayName"],
        address: json["address"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "regionCode": regionCode,
        "regionName": regionName,
        "provinceCode": provinceCode,
        "provinceName": provinceName,
        "townCode": townCode,
        "townName": townName,
        "barangayCode": barangayCode,
        "barangayName": barangayName,
        "address": address,
        "isDefault": isDefault,
      };
}
