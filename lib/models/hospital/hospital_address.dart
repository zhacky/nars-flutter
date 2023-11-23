class HospitalAddress {
  HospitalAddress({
    this.id,
    this.informationId,
    this.hospitalId,
    required this.regionCode,
    this.regionName,
    required this.provinceCode,
    this.provinceName,
    required this.townCode,
    this.townName,
    required this.barangayCode,
    this.barangayName,
    required this.address,
    this.information,
    this.isDeleted,
    this.createdDate,
    required this.isDefault,
  });

  int? id;
  int? informationId;
  int? hospitalId;
  String regionCode;
  String? regionName;
  String provinceCode;
  String? provinceName;
  String townCode;
  String? townName;
  String barangayCode;
  String? barangayName;
  String address;
  dynamic information;
  bool? isDeleted;
  bool isDefault;
  DateTime? createdDate;

  factory HospitalAddress.fromJson(Map<String, dynamic> json) =>
      HospitalAddress(
        id: json["id"],
        informationId: json["informationId"],
        hospitalId: json["hospitalId"],
        regionCode: json["regionCode"],
        regionName: json["regionName"],
        provinceCode: json["provinceCode"],
        provinceName: json["provinceName"],
        townCode: json["townCode"],
        townName: json["townName"],
        barangayCode: json["barangayCode"],
        barangayName: json["barangayName"],
        address: json["address"],
        information: json["information"],
        isDeleted: json["isDeleted"],
        isDefault: json["isDefault"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "informationId": informationId,
        "hospitalId": hospitalId,
        "regionCode": regionCode,
        "regionName": regionName,
        "provinceCode": provinceCode,
        "provinceName": provinceName,
        "townCode": townCode,
        "townName": townName,
        "barangayCode": barangayCode,
        "barangayName": barangayName,
        "address": address,
        "information": information,
        "isDeleted": isDeleted,
        "isDefault": isDefault,
        "createdDate":
            createdDate != null ? createdDate!.toIso8601String() : null,
      };
}
