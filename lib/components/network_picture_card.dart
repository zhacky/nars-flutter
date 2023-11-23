import 'package:nars/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkPictureCard extends StatelessWidget {
  const NetworkPictureCard({
    Key? key,
    required this.imageScr,
    required this.title,
    required this.press,
    this.width = 50,
    this.height = 50,
    this.horizontal = defaultPadding / 4,
    this.vertical = defaultPadding / 2,
    this.boxShape = BoxShape.rectangle,
    this.boxFit = BoxFit.cover,
    this.color = Colors.white,
    this.assetImage = false,
  }) : super(key: key);

  final String imageScr, title;
  final VoidCallback press;
  final double width, height, horizontal, vertical;
  final BoxShape boxShape;
  final BoxFit boxFit;
  final Color color;
  final bool assetImage;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
          ),
        ),
        overlayColor: MaterialStateColor.resolveWith(
            (states) => kPrimaryColor.withOpacity(0.3)),
        backgroundColor: MaterialStateColor.resolveWith((states) => color),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageScr.isNotEmpty) ...[
              if (assetImage)
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    shape: boxShape,
                    image: DecorationImage(
                      image: AssetImage(imageScr),
                      fit: boxFit,
                    ),
                  ),
                ),
              if (!assetImage)
                CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: imageScr,
                  imageBuilder: (context, imageProvider) => Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      shape: boxShape,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: boxFit,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    height: height,
                    width: width,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
