import 'dart:convert';

SetDefaultAddressParam setDefaultAddressParamFromJson(String str) =>
    SetDefaultAddressParam.fromJson(json.decode(str));

String setDefaultAddressParamToJson(SetDefaultAddressParam data) =>
    json.encode(data.toJson());

class SetDefaultAddressParam {
  SetDefaultAddressParam({
    required this.profileId,
    required this.addressId,
  });

  int profileId;
  int addressId;

  factory SetDefaultAddressParam.fromJson(Map<String, dynamic> json) =>
      SetDefaultAddressParam(
        profileId: json["profileId"],
        addressId: json["addressId"],
      );

  Map<String, dynamic> toJson() => {
        "profileId": profileId,
        "addressId": addressId,
      };
}
