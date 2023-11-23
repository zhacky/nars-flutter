import 'package:nars/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardNetworkImage extends StatelessWidget {
  const CardNetworkImage({
    Key? key,
    required this.imageLink,
    required this.title,
    this.selected = false,
    required this.press,
  }) : super(key: key);

  final String imageLink, title;
  final bool selected;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(120, 0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            side: selected
                ? const BorderSide(
                    width: 2,
                    color: kPrimaryColor,
                  )
                : BorderSide.none,
          ),
        ),
        overlayColor: MaterialStateColor.resolveWith(
            (states) => kPrimaryColor.withOpacity(0.3)),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 4, vertical: defaultPadding / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CachedNetworkImage(
            //   key: UniqueKey(),
            //   imageUrl: imageLink,
            //   imageBuilder: (context, imageProvider) => Container(
            //     height: 50,
            //     width: 50,
            //     decoration: BoxDecoration(
            //       shape: boxShape,
            //       image: DecorationImage(
            //         image: imageProvider,
            //         fit: boxFit,
            //       ),
            //     ),
            //   ),
            //   progressIndicatorBuilder: (context, url, downloadProgress) =>
            //       SizedBox(
            //     height: height,
            //     width: width,
            //     child: SizedBox(
            //       height: 50,
            //       width: 50,
            //       child: Center(
            //         child: CircularProgressIndicator(
            //           value: downloadProgress.progress,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 50,
              width: 50,
              child: CachedNetworkImage(
                imageUrl: imageLink,
                placeholder: (context, url) => const SizedBox(
                  height: 50,
                  width: 50,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle2,
            )
          ],
        ),
      ),
    );
  }
}
