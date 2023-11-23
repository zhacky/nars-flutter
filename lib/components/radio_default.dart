import 'package:flutter/material.dart';

class RadioDefault extends StatelessWidget {
  const RadioDefault({
    Key? key,
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  final String text;
  final int value;
  final int? groupValue;
  final Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
