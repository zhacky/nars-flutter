import 'dart:convert';

import 'package:nars/models/payment/dragonpay_body_cc.dart';

PaySubscriptionParam paySubscriptionParamFromJson(String str) =>
    PaySubscriptionParam.fromJson(json.decode(str));

String paySubscriptionParamToJson(PaySubscriptionParam data) =>
    json.encode(data.toJson());

class PaySubscriptionParam {
  PaySubscriptionParam({
    required this.userId,
    required this.subscriptionType,
    required this.dragonPayBodyCc,
  });

  int userId;
  int subscriptionType;
  DragonPayBodyCc dragonPayBodyCc;

  factory PaySubscriptionParam.fromJson(Map<String, dynamic> json) =>
      PaySubscriptionParam(
        userId: json["userId"],
        subscriptionType: json["subscriptionType"],
        dragonPayBodyCc: DragonPayBodyCc.fromJson(json["dragonPayBodyCC"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "subscriptionType": subscriptionType,
        "dragonPayBodyCC": dragonPayBodyCc.toJson(),
      };
}
