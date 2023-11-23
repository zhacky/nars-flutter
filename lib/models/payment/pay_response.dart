import 'dart:convert';

PayResponse payResponseFromJson(String str) =>
    PayResponse.fromJson(json.decode(str));

String payResponseToJson(PayResponse data) => json.encode(data.toJson());

class PayResponse {
  PayResponse({
    required this.status,
    required this.txnId,
    required this.url,
  });

  String status;
  String txnId;
  String url;

  factory PayResponse.fromJson(Map<String, dynamic> json) => PayResponse(
        status: json["status"],
        txnId: json["txnId"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "txnId": txnId,
        "url": url,
      };
}
