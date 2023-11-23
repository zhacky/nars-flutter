import 'dart:convert';

JoinVideoCallParam joinVideoCallParamFromJson(String str) =>
    JoinVideoCallParam.fromJson(json.decode(str));

String joinVideoCallParamToJson(JoinVideoCallParam data) =>
    json.encode(data.toJson());

class JoinVideoCallParam {
  JoinVideoCallParam({
    required this.appointmentId,
    required this.profileId,
  });

  int appointmentId;
  int profileId;

  factory JoinVideoCallParam.fromJson(Map<String, dynamic> json) =>
      JoinVideoCallParam(
        appointmentId: json["appointmentId"],
        profileId: json["profileId"],
      );

  Map<String, dynamic> toJson() => {
        "appointmentId": appointmentId,
        "profileId": profileId,
      };
}
