import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class ContainerWarning extends StatelessWidget {
  const ContainerWarning({
    Key? key,
    required this.size,
    required this.text,
  }) : super(key: key);

  final Size size;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(defaultPadding),
      color: Colors.orangeAccent.withOpacity(0.9),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
