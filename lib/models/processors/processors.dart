import 'dart:convert';

List<Processor> processorsFromJson(String str) =>
    List<Processor>.from(json.decode(str).map((x) => Processor.fromJson(x)));

Processor processorFromJson(String str) => Processor.fromJson(json.decode(str));

String processorToJson(Processor data) => json.encode(data.toJson());

class Processor {
  Processor({
    required this.code,
    required this.description,
  });

  String code;
  String description;

  factory Processor.fromJson(Map<String, dynamic> json) => Processor(
        code: json["code"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
      };
}
