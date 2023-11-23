import 'package:flutter/material.dart';

class SubtitleDefault extends StatelessWidget {
  const SubtitleDefault({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}
