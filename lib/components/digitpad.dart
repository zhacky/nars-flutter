import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class DigitPad extends StatelessWidget {
  const DigitPad({
    Key? key,
    required this.press,
    required this.value,
    this.icon = const Text(''),
    this.isIcon = false,
  }) : super(key: key);

  final VoidCallback press;
  final String value;
  final Widget icon;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: double.maxFinite,
        child: TextButton(
          onPressed: press,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
              ),
            ),
            overlayColor: MaterialStateColor.resolveWith(
                (states) => kPrimaryColor.withOpacity(0.3)),
          ),
          child: isIcon
              ? icon
              : Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF444444),
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ),
      ),
    );
  }
}
