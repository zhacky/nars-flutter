import 'dart:convert';

Specialization specializationFromJson(String str) =>
    Specialization.fromJson(json.decode(str));

String specializationToJson(Specialization data) => json.encode(data.toJson());

class Specialization {
  Specialization({
    required this.id,
    required this.name,
    this.imageLink,
    required this.practitionerSpecialties,
    this.isDeleted,
    this.isSelected = false,
    this.createdDate,
  });

  int id;
  String name;
  String? imageLink;
  dynamic practitionerSpecialties;
  bool? isDeleted;
  bool isSelected;
  DateTime? createdDate;

  factory Specialization.fromJson(Map<String, dynamic> json) => Specialization(
        id: json["id"],
        name: json["name"],
        imageLink: json["imageLink"],
        practitionerSpecialties: json["practitionerSpecialties"],
        isDeleted: json["isDeleted"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageLink": imageLink,
        "practitionerSpecialties": practitionerSpecialties,
        "isDeleted": isDeleted,
        "createdDate": createdDate?.toIso8601String(),
      };
}

class SpecializationDemo {
  final String icon, title;
  bool selected;

  SpecializationDemo({
    required this.icon,
    required this.title,
    required this.selected,
  });
}

List<SpecializationDemo> specializationsDemo = [
  SpecializationDemo(
    icon: "assets/icons/medicine.svg",
    title: "Pediatrcian",
    selected: true,
  ),
  // Specialization(
  //   icon: "assets/icons/brain.svg",
  //   title: "Neurosurgeon",
  // ),
  SpecializationDemo(
    icon: "assets/icons/heart.svg",
    title: "Cardiologist",
    selected: false,
  ),
  SpecializationDemo(
    icon: "assets/icons/eye.svg",
    title: "Opthalmology",
    selected: true,
  ),
  SpecializationDemo(
    icon: "assets/icons/virus.svg",
    title: "COVID-19",
    selected: false,
  ),
  SpecializationDemo(
    icon: "assets/icons/tooth.svg",
    title: "Dentist",
    selected: false,
  ),
  SpecializationDemo(
    icon: "assets/icons/lungs.svg",
    title: "Pulmonologist",
    selected: false,
  ),
  SpecializationDemo(
    icon: "assets/icons/bones.svg",
    title: "Orthopedic",
    selected: false,
  ),
];
