class UserAccount {
  UserAccount({
    required this.phoneNumber,
    required this.email,
    required this.pin,
  });

  String phoneNumber;
  String email;
  String pin;

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        pin: json["pin"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "email": email,
        "pin": pin,
      };
}
