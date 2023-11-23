class DragonPayBodyCc {
  DragonPayBodyCc({
    required this.amount,
    required this.currency,
    required this.description,
    required this.email,
    required this.procId,
    required this.param1,
    required this.param2,
    required this.billingDetails,
    required this.ipAddress,
    required this.userAgent,
  });

  String amount;
  String currency;
  String description;
  String email;
  String procId;
  String param1;
  String param2;
  BillingDetails billingDetails;
  String ipAddress;
  String userAgent;

  factory DragonPayBodyCc.fromJson(Map<String, dynamic> json) =>
      DragonPayBodyCc(
        amount: json["amount"],
        currency: json["currency"],
        description: json["description"],
        email: json["email"],
        procId: json["procId"],
        param1: json["param1"],
        param2: json["param2"],
        billingDetails: BillingDetails.fromJson(json["billingDetails"]),
        ipAddress: json["ipAddress"],
        userAgent: json["userAgent"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "currency": currency,
        "description": description,
        "email": email,
        "procId": procId,
        "param1": param1,
        "param2": param2,
        "billingDetails": billingDetails.toJson(),
        "ipAddress": ipAddress,
        "userAgent": userAgent,
      };
}

class BillingDetails {
  BillingDetails({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.address1,
    required this.address2,
    required this.city,
    required this.province,
    required this.country,
    required this.zipCode,
    required this.telNo,
    required this.email,
  });

  String firstName;
  String middleName;
  String lastName;
  String address1;
  String address2;
  String city;
  String province;
  String country;
  String zipCode;
  String telNo;
  String email;

  factory BillingDetails.fromJson(Map<String, dynamic> json) => BillingDetails(
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        address1: json["address1"],
        address2: json["address2"],
        city: json["city"],
        province: json["province"],
        country: json["country"],
        zipCode: json["zipCode"],
        telNo: json["telNo"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "address1": address1,
        "address2": address2,
        "city": city,
        "province": province,
        "country": country,
        "zipCode": zipCode,
        "telNo": telNo,
        "email": email,
      };
}
