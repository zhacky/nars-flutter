import 'package:nars/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonDefault extends StatelessWidget {
  const ButtonDefault({
    Key? key,
    this.svgScr,
    this.title,
    required this.press,
    this.bgColor = kPrimaryColor,
    this.fontColor = Colors.white,
    this.horizontalPadding = defaultPadding,
    this.verticalPadding = defaultPadding,
    this.width,
    this.svgHeight = 20,
    this.svgWidth = 20,
    this.fontSize = 14,
  }) : super(key: key);

  final String? svgScr;
  final String? title;
  final Color bgColor, fontColor;
  final VoidCallback press;
  final double horizontalPadding, verticalPadding;
  final double? width;
  final double svgHeight;
  final double svgWidth;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      child: Material(
        color: bgColor,
        child: InkWell(
          onTap: press,
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (svgScr != null)
                  SizedBox(
                    height: svgHeight,
                    width: svgWidth,
                    child: SvgPicture.asset(
                      svgScr!,
                      color: Colors.white,
                    ),
                  ),
                if (title != null)
                  Padding(
                    padding: EdgeInsets.only(
                        left: svgScr != null ? defaultPadding * 0.5 : 0),
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: fontColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
