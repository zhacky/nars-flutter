import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class CheckboxTileDefault extends StatelessWidget {
  const CheckboxTileDefault({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String text;
  final bool value;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(text),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: kPrimaryColor,
      value: value,
      onChanged: onChanged,
    );
  }
}
