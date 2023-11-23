import 'dart:convert';

UserRequestForWithdrawalResponse userRequestForWithdrawalResponseFromJson(
        String str) =>
    UserRequestForWithdrawalResponse.fromJson(json.decode(str));

String userRequestForWithdrawalResponseToJson(
        UserRequestForWithdrawalResponse data) =>
    json.encode(data.toJson());

class UserRequestForWithdrawalResponse {
  UserRequestForWithdrawalResponse({
    required this.code,
    required this.message,
  });

  int code;
  String message;

  factory UserRequestForWithdrawalResponse.fromJson(
          Map<String, dynamic> json) =>
      UserRequestForWithdrawalResponse(
        code: json["Code"],
        message: json["Message"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message": message,
      };
}
