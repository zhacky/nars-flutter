class NurseAddedFeeItem {
  NurseAddedFeeItem({
    required this.id,
    required this.name,
    required this.description,
    required this.percentage,
    required this.nurseAddedFeeType,
  });

  int id;
  String name;
  String description;
  double percentage;
  String nurseAddedFeeType;

  factory NurseAddedFeeItem.fromJson(Map<String, dynamic> json) =>
      NurseAddedFeeItem(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        percentage: json["percentage"],
        nurseAddedFeeType: json["nurseAddedFeeType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "percentage": percentage,
        "nurseAddedFeeType": nurseAddedFeeType,
      };
}
