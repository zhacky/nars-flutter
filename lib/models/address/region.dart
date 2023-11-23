import 'dart:convert';

import 'package:flutter/material.dart';

List<Region> regionsFromJson(String str) =>
    List<Region>.from(json.decode(str).map((x) => Region.fromJson(x)));

Region regionFromJson(String str) => Region.fromJson(json.decode(str));

String regionToJson(Region data) => json.encode(data.toJson());

class Region {
  Region({
    required this.id,
    required this.code,
    required this.name,
    required this.regionName,
  });

  int id;
  String code;
  String name;
  String regionName;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        regionName: json["regionName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "regionName": regionName,
      };
}
