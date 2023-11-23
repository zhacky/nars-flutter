import 'dart:convert';

BannerPhoto bannerPhotoFromJson(String str) =>
    BannerPhoto.fromJson(json.decode(str));

String bannerPhotoToJson(BannerPhoto data) => json.encode(data.toJson());

class BannerPhoto {
  BannerPhoto({
    required this.id,
    required this.imageLink,
    required this.order,
    required this.isDeleted,
    required this.createdDate,
  });

  int id;
  String imageLink;
  int order;
  bool isDeleted;
  DateTime createdDate;

  factory BannerPhoto.fromJson(Map<String, dynamic> json) => BannerPhoto(
        id: json["id"],
        imageLink: json["imageLink"],
        order: json["order"],
        isDeleted: json["isDeleted"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageLink": imageLink,
        "order": order,
        "isDeleted": isDeleted,
        "createdDate": createdDate.toIso8601String(),
      };
}

// class Banner {
//   final String imgScr;

//   Banner({
//     required this.imgScr,
//   });
// }

// List<Banner> banners = [
//   Banner(
//     imgScr: "assets/images/banners/banner1.png",
//   ),
//   Banner(
//     imgScr: "assets/images/banners/banner2.png",
//   ),
// ];
