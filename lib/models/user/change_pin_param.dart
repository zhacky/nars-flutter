import 'dart:convert';

ChangePinParam changePinParamFromJson(String str) =>
    ChangePinParam.fromJson(json.decode(str));

String changePinParamToJson(ChangePinParam data) => json.encode(data.toJson());

class ChangePinParam {
  ChangePinParam({
    required this.oldPin,
    required this.newPin,
  });

  String oldPin;
  String newPin;

  factory ChangePinParam.fromJson(Map<String, dynamic> json) => ChangePinParam(
        oldPin: json["oldPin"],
        newPin: json["newPin"],
      );

  Map<String, dynamic> toJson() => {
        "oldPin": oldPin,
        "newPin": newPin,
      };
}
