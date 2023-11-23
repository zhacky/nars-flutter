import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class CardAssetImage extends StatelessWidget {
  const CardAssetImage({
    Key? key,
    this.imageScr,
    required this.title,
    required this.press,
    this.selected = false,
    this.width = 50,
    this.height = 50,
    this.horizontal = defaultPadding / 4,
    this.vertical = defaultPadding / 2,
    this.boxShape = BoxShape.rectangle,
    this.boxFit = BoxFit.cover,
    this.color = Colors.white,
  }) : super(key: key);

  final String? imageScr;
  final bool selected;
  final String title;
  final VoidCallback press;
  final double width, height, horizontal, vertical;
  final BoxShape boxShape;
  final BoxFit boxFit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            side: selected
                ? const BorderSide(
                    width: 2,
                    color: kPrimaryColor,
                  )
                : BorderSide.none,
          ),
        ),
        overlayColor: MaterialStateColor.resolveWith(
            (states) => kPrimaryColor.withOpacity(0.3)),
        backgroundColor: MaterialStateColor.resolveWith((states) => color),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageScr != null) ...[
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  // color: Colors.redAccent,
                  shape: boxShape,
                  image: DecorationImage(
                    image: AssetImage(imageScr!),
                    fit: boxFit,
                  ),
                ),
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
