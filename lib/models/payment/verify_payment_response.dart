import 'dart:convert';

VerifyPaymentResponse verifyPaymentResponseFromJson(String str) =>
    VerifyPaymentResponse.fromJson(json.decode(str));

String verifyPaymentResponseToJson(VerifyPaymentResponse data) =>
    json.encode(data.toJson());

class VerifyPaymentResponse {
  VerifyPaymentResponse({
    this.paymentStatus,
    this.dateSettled,
  });

  String? paymentStatus;
  DateTime? dateSettled;

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) =>
      VerifyPaymentResponse(
        paymentStatus:
            json["paymentStatus"] == null ? null : json["paymentStatus"],
        dateSettled: json["dateSettled"] == null
            ? null
            : DateTime.parse(json["dateSettled"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentStatus": paymentStatus == null ? null : paymentStatus,
        "dateSettled":
            dateSettled == null ? null : dateSettled!.toIso8601String(),
      };
}
