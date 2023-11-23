import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class ButtonTextDefault extends StatelessWidget {
  const ButtonTextDefault({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(defaultPadding),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(defaultBorderRadius),
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
