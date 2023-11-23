import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  const TitleDefault({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 18),
    );
  }
}
