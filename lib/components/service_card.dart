import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    Key? key,
    required this.title,
    required this.imgScr,
    required this.onTap,
    this.columns = 1,
    this.color = Colors.white,
  }) : super(key: key);

  final String title, imgScr;
  final VoidCallback onTap;
  final int columns;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        child: Container(
          width: constraint.maxWidth / columns - (defaultPadding / columns),
          // height: 233,
          decoration: BoxDecoration(
            color: color,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              splashColor: kPrimaryColor.withOpacity(0.3),
              highlightColor: Colors.transparent,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Image.asset(imgScr),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
