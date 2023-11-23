import 'package:nars/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
    required this.svgScr,
  }) : super(key: key);

  final String title, value, svgScr;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              splashColor: kPrimaryColor.withOpacity(0.3),
              highlightColor: Colors.transparent,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      svgScr,
                      width: 35,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(width: defaultPadding),
                    RichText(
                      text: TextSpan(
                        text: title + '\n',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                value,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
