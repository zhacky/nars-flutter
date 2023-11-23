import 'package:nars/components/card_container.dart';
import 'package:flutter/material.dart';

class ButtonTextField extends StatelessWidget {
  const ButtonTextField({
    Key? key,
    required this.press,
    this.title,
    this.label,
    this.icon,
    this.suffixIcon,
    this.leftPadding = 24,
    this.rightPadding = 0,
  }) : super(key: key);

  final String? title;
  final String? label;
  final VoidCallback press;
  final Widget? icon;
  final Widget? suffixIcon;
  final double leftPadding;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: press,
          child: CardContainer(
            // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            padding: EdgeInsets.fromLTRB(leftPadding, 18, rightPadding, 18),
            child: Row(
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(
                    width: 16,
                  ),
                ],
                Text(
                  title ?? label ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: title != null ? Colors.black87 : Colors.black54,
                  ),
                ),
                const Spacer(),
                if (suffixIcon != null) suffixIcon!,
              ],
            ),
          ),
        ),
        if (title != null)
          Positioned(
            left: leftPadding,
            top: -7,
            child: Text(
              label ?? '',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
