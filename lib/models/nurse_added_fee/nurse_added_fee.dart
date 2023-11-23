import 'dart:convert';

import 'package:nars/models/nurse_added_fee/nurse_added_fee_item.dart';

List<NurseAddedFee> nurseAddedFeesFromJson(String str) =>
    List<NurseAddedFee>.from(
        json.decode(str).map((x) => NurseAddedFee.fromJson(x)));

NurseAddedFee nurseAddedFeeFromJson(String str) =>
    NurseAddedFee.fromJson(json.decode(str));

String nurseAddedFeeToJson(NurseAddedFee data) => json.encode(data.toJson());

class NurseAddedFee {
  NurseAddedFee({
    required this.nurseDetail,
    required this.item,
  });

  String nurseDetail;
  List<NurseAddedFeeItem> item;

  factory NurseAddedFee.fromJson(Map<String, dynamic> json) => NurseAddedFee(
        nurseDetail: json["nurseDetail"],
        item: List<NurseAddedFeeItem>.from(
            json["item"].map((x) => NurseAddedFeeItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nurseDetail": nurseDetail,
        "item": List<dynamic>.from(item.map((x) => x.toJson())),
      };
}
