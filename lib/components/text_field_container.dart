import 'package:nars/components/card_container.dart';
import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding:
          const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 0),
      child: child,
    );
  }
}
