import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:flutter/material.dart';

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final List<Widget>? actions;

  AppBarDefault({
    Key? key,
    required this.title,
    this.actions,
  })  : preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Responsive.isDesktop(context)
        ? PreferredSize(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: defaultPadding / 2,
                horizontal: size.width * 0.30,
              ),
              decoration: const BoxDecoration(color: kPrimaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(
                    color: Colors.white,
                  ),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                  ),
                  Row(
                    children: actions ?? [const SizedBox.shrink()],
                  )
                ],
              ),
            ),
            preferredSize: Size(
              size.width,
              56,
            ),
          )
        : AppBar(
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            elevation: 0,
            leading: const BackButton(
              color: Colors.white,
            ),
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
            actions: actions,
          );
  }
}
