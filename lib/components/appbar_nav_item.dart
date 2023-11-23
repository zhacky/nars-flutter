import 'package:nars/components/card_container.dart';
import 'package:nars/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarNavItem extends StatelessWidget {
  const AppBarNavItem({
    Key? key,
    this.svgScr = 'assets/icons/profile.svg',
    required this.title,
    required this.press,
    this.isActive = false,
  }) : super(key: key);

  final String svgScr;
  final String title;
  final VoidCallback press;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CardContainer(
            padding: const EdgeInsets.all(defaultPadding / 1.5),
            color: isActive ? kPrimaryColor : Colors.transparent,
            child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: isActive ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
