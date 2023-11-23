import 'dart:convert';

import 'package:nars/enumerables/document_status.dart';
import 'package:nars/enumerables/document_type.dart';

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  Document({
    this.id,
    this.type,
    required this.imageLink,
    this.documentStatus,
    required this.other,
  });

  int? id;
  DocumentType? type;
  String imageLink;
  DocumentStatus? documentStatus;
  dynamic other;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        type:
            json["type"] == null ? null : documentTypeValues.map[json["type"]],
        imageLink: json["imageLink"],
        documentStatus: json["documentStatus"] == null
            ? null
            : documentStatusValues.map[json["documentStatus"]],
        other: json["other"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": documentTypeValues.reverse![type],
        "imageLink": imageLink,
        "documentStatus": documentStatusValues.reverse![documentStatus],
        "other": other,
      };
}
