import 'package:flutter/material.dart';

SnackBar snackBarDefault({
  String text = 'Something went wrong, please try again',
  double? fontSize = 20,
  Color? color = Colors.redAccent,
}) {
  return SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
      ),
    ),
    backgroundColor: color,
  );
}
