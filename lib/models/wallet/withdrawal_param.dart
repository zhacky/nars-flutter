import 'dart:convert';

UserRequestForWithdrawalParam userRequestForWithdrawalParamFromJson(
        String str) =>
    UserRequestForWithdrawalParam.fromJson(json.decode(str));

String userRequestForWithdrawalParamToJson(
        UserRequestForWithdrawalParam data) =>
    json.encode(data.toJson());

class UserRequestForWithdrawalParam {
  UserRequestForWithdrawalParam({
    required this.amount,
    required this.procId,
    required this.accountNumber,
  });

  double amount;
  String procId;
  String accountNumber;

  factory UserRequestForWithdrawalParam.fromJson(Map<String, dynamic> json) =>
      UserRequestForWithdrawalParam(
        amount: json["amount"],
        procId: json["procId"],
        accountNumber: json["accountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "procId": procId,
        "accountNumber": accountNumber,
      };
}
