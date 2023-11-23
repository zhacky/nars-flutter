import 'dart:convert';

import 'package:nars/enumerables/usertype.dart';
import 'package:flutter/material.dart';

Auth authFromJson(String str) => Auth.fromJson(json.decode(str));

String authToJson(Auth data) => json.encode(data.toJson());

class Auth with ChangeNotifier {
  Auth({
    required this.id,
    required this.name,
    required this.role,
    required this.expiration,
    required this.isExpired,
  });

  int id;
  String name;
  List<String> role;
  late UserType userType = UserType.values.firstWhere((x) => x.name == role[0]);
  DateTime? expiration;
  bool? isExpired;

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        id: json["id"],
        name: json["name"],
        role: List<String>.from(json["role"].map((x) => x)),
        expiration: json["expiration"] == null
            ? null
            : DateTime.parse(json["expiration"]),
        isExpired: json["isExpired"] == null ? null : json["isExpired"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": List<dynamic>.from(role.map((x) => x)),
        "expiration": expiration == null ? null : expiration!.toIso8601String(),
        "isExpired": isExpired == null ? null : isExpired,
      };
}
