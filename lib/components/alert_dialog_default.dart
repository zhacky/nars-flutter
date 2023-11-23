import 'package:flutter/material.dart';

class AlertDialogDefault extends StatelessWidget {
  const AlertDialogDefault({
    Key? key,
    this.title = 'Done',
    this.content = 'Saved successfully',
    required this.press,
  }) : super(key: key);

  final String title, content;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: press,
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
