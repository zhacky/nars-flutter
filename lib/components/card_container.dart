import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    Key? key,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(defaultPadding),
    this.margin,
    this.color = Colors.white,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(defaultBorderRadius),
    ),
    this.image,
    this.child,
    this.boxShape = BoxShape.rectangle,
  }) : super(key: key);

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final DecorationImage? image;
  final Widget? child;
  final BoxShape boxShape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        shape: boxShape,
        color: color,
        borderRadius: borderRadius,
        image: image,
      ),
      child: child,
    );
  }
}
