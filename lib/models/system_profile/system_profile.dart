import 'dart:convert';

SystemProfile systemProfileFromJson(String str) =>
    SystemProfile.fromJson(json.decode(str));

String systemProfileToJson(SystemProfile data) => json.encode(data.toJson());

class SystemProfile {
  SystemProfile({
    required this.id,
    required this.isActivated,
    this.name,
    required this.systemFee,
    required this.commissionFromNursePercentage,
    required this.nurseFeePerHour,
    required this.covidPercentageFee,
    required this.practitionerSubscriptionFee,
    required this.isDeleted,
    required this.createdDate,
  });

  int id;
  bool isActivated;
  String? name;
  double systemFee;
  double commissionFromNursePercentage;
  double nurseFeePerHour;
  double covidPercentageFee;
  double practitionerSubscriptionFee;
  bool isDeleted;
  DateTime createdDate;

  factory SystemProfile.fromJson(Map<String, dynamic> json) => SystemProfile(
        id: json["id"],
        isActivated: json["isActivated"],
        name: json["name"],
        systemFee: json["systemFee"],
        commissionFromNursePercentage: json["commissionFromNursePercentage"],
        nurseFeePerHour: json["nurseFeePerHour"],
        covidPercentageFee: json["covidPercentageFee"],
        practitionerSubscriptionFee: json["practitionerSubscriptionFee"],
        isDeleted: json["isDeleted"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isActivated": isActivated,
        "name": name,
        "systemFee": systemFee,
        "commissionFromNursePercentage": commissionFromNursePercentage,
        "nurseFeePerHour": nurseFeePerHour,
        "covidPercentageFee": covidPercentageFee,
        "practitionerSubscriptionFee": practitionerSubscriptionFee,
        "isDeleted": isDeleted,
        "createdDate": createdDate.toIso8601String(),
      };
}
