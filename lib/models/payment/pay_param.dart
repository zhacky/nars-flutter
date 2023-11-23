import 'dart:convert';

import 'package:nars/models/payment/dragonpay_body_cc.dart';

PayParam payParamFromJson(String str) => PayParam.fromJson(json.decode(str));

String payParamToJson(PayParam data) => json.encode(data.toJson());

class PayParam {
  PayParam({
    required this.appointmentId,
    required this.dragonPayBodyCc,
  });

  int appointmentId;
  DragonPayBodyCc dragonPayBodyCc;

  factory PayParam.fromJson(Map<String, dynamic> json) => PayParam(
        appointmentId: json["appointmentId"],
        dragonPayBodyCc: DragonPayBodyCc.fromJson(json["dragonPayBodyCC"]),
      );

  Map<String, dynamic> toJson() => {
        "appointmentId": appointmentId,
        "dragonPayBodyCC": dragonPayBodyCc.toJson(),
      };
}
