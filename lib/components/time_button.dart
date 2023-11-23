import 'package:nars/components/button_default.dart';
import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class TimeButton extends StatelessWidget {
  const TimeButton({
    Key? key,
    int? selectedIndex,
    required this.press,
    required this.time,
    this.selectedTime,
    required this.index,
    required this.label,
    this.occupied = false,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final String label;
  final DateTime? time;
  final DateTime? selectedTime;
  final int index;
  final int? _selectedIndex;
  final VoidCallback press;
  final bool occupied;

  @override
  Widget build(BuildContext context) {
    return ButtonDefault(
      title: label,
      width: 93,
      verticalPadding: defaultPadding / 1.2,
      horizontalPadding: 0,
      bgColor: selectedTime == time
          ? kPrimaryColor
          : (occupied ? Colors.grey.shade400 : Colors.grey.shade200),
      fontColor: selectedTime == time
          ? Colors.white
          : (occupied ? Colors.black54 : Colors.black87),
      press: press,
    );
  }
}
