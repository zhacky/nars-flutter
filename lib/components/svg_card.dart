import 'package:nars/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgCard extends StatelessWidget {
  const SvgCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String icon, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(120, 0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
          ),
        ),
        overlayColor: MaterialStateColor.resolveWith(
            (states) => kPrimaryColor.withOpacity(0.3)),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 4, vertical: defaultPadding / 2),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: SvgPicture.asset(icon),
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle2,
            )
          ],
        ),
      ),
    );
  }
}
