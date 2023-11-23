import 'package:nars/models/demo/address_demo.dart';

class HospitalDemo {
  final String image, title;
  final Address address;

  HospitalDemo({
    required this.image,
    required this.title,
    required this.address,
  });
}

List<HospitalDemo> hospitals = [
  HospitalDemo(
    image: "assets/images/hospitals/PHC.png",
    title: "Philippine Heart Center",
    address: addresses[3],
  ),
  HospitalDemo(
    image: "assets/images/hospitals/StLuke.png",
    title: "St. Luke's Medical Center Quezon City",
    address: addresses[3],
  ),
  HospitalDemo(
    image: "assets/images/hospitals/MMC.png",
    title: "Makati Medical Center",
    address: addresses[3],
  ),
  HospitalDemo(
    image: "assets/images/hospitals/AHMC.png",
    title: "Asian Hospital & Medical Centre",
    address: addresses[3],
  ),
];
