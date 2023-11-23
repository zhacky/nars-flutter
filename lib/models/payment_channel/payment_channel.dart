// To parse this JSON data, do
//
//     final paymentChannel = paymentChannelFromJson(jsonString);

import 'dart:convert';

List<PaymentChannel> paymentChannelsFromJson(String str) =>
    List<PaymentChannel>.from(
        json.decode(str).map((x) => PaymentChannel.fromJson(x)));

PaymentChannel paymentChannelFromJson(String str) =>
    PaymentChannel.fromJson(json.decode(str));

String paymentChannelToJson(PaymentChannel data) => json.encode(data.toJson());

class PaymentChannel {
  PaymentChannel({
    required this.procId,
    required this.name,
  });

  String procId;
  String name;

  factory PaymentChannel.fromJson(Map<String, dynamic> json) => PaymentChannel(
        procId: json["procId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "procId": procId,
        "name": name,
      };
}
