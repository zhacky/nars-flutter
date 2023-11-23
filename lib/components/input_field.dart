import 'package:nars/components/text_field_container.dart';
import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String hintText;
  final Widget icon;
  final ValueChanged<String> onChanged;

  const InputBox({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.icon = const Text(''),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: icon,
          // hintText: hintText,
          labelText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
