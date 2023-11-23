import 'package:nars/constants.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:flutter/material.dart';

class TextPill extends StatelessWidget {
  const TextPill({
    Key? key,
    required this.status,
  }) : super(key: key);

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding / 2, vertical: defaultPadding / 6),
      decoration: BoxDecoration(
          color: statusColor(status),
          borderRadius: BorderRadius.circular(defaultBorderRadius)),
      child: Text(
        status,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
