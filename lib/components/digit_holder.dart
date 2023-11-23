import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class DigitHolder extends StatelessWidget {
  const DigitHolder({
    Key? key,
    required this.width,
    required this.selectedIndex,
    required this.index,
    this.code = '',
    this.paddingRight = defaultPadding,
  }) : super(key: key);

  final int selectedIndex, index;
  final String code;
  final double paddingRight;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: paddingRight),
      height: width * 0.11,
      width: width * 0.11,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: index == selectedIndex ? Colors.blue.shade200 : Colors.black54,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: index == selectedIndex
                ? Colors.blue.shade200
                : Colors.transparent,
            offset: const Offset(0, 0),
            spreadRadius: 1.5,
            blurRadius: 2,
          )
        ],
      ),
      child: code.length > index
          ? Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF444444),
                shape: BoxShape.circle,
              ),
            )
          : Container(),
    );
  }
}
