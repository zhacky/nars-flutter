import 'package:nars/components/text_pill.dart';
import 'package:nars/constants.dart';
import 'package:nars/models/document/document.dart';
import 'package:flutter/material.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile({
    Key? key,
    required this.document,
    required this.press,
  }) : super(key: key);

  final Document document;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      horizontalTitleGap: 4,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      title: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(document.type!.name),
          TextPill(status: document.documentStatus!.name),
        ],
      ),
      onTap: press,
    );
  }
}
