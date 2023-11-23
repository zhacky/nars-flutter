import 'dart:convert';

Wallet walletFromJson(String str) => Wallet.fromJson(json.decode(str));

String walletToJson(Wallet data) => json.encode(data.toJson());

class Wallet {
  Wallet({
    required this.id,
    required this.name,
    required this.amount,
  });

  int id;
  String name;
  double amount;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        name: json["name"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
      };
}
