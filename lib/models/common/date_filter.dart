class DateFilterCommon {
  DateFilterCommon({
    required this.start,
    this.end,
  });

  DateTime start;
  DateTime? end;

  factory DateFilterCommon.fromJson(Map<String, dynamic> json) =>
      DateFilterCommon(
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
      );

  Map<String, dynamic> toJson() => {
        "start": start.toIso8601String(),
        "end": end == null ? null : end!.toIso8601String(),
      };
}
