import 'package:nars/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultListTile extends StatelessWidget {
  const DefaultListTile({
    Key? key,
    required this.title,
    required this.svgScr,
    required this.press,
  }) : super(key: key);

  final String title;
  final String svgScr;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      horizontalTitleGap: 4,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      title: Text(title),
      leading: SvgPicture.asset(
        svgScr,
        color: Colors.black,
        width: 30,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: press,
      ),
      onTap: press,
    );
  }
}
