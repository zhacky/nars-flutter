import 'dart:convert';

LinkResponse linkResponseFromJson(String str) =>
    LinkResponse.fromJson(json.decode(str));

String linkResponseToJson(LinkResponse data) => json.encode(data.toJson());

class LinkResponse {
  LinkResponse({
    required this.link,
  });

  String link;

  factory LinkResponse.fromJson(Map<String, dynamic> json) => LinkResponse(
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
      };
}
