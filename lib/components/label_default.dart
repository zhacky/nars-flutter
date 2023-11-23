import 'package:flutter/material.dart';

class LabelDefault extends StatelessWidget {
  const LabelDefault({
    Key? key,
    required this.header,
    required this.text,
  }) : super(key: key);

  final String header;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(fontWeight: FontWeight.normal, color: Colors.black54),
        ),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
