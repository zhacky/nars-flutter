import 'package:nars/components/card_container.dart';
import 'package:nars/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageDefault extends StatelessWidget {
  const CachedNetworkImageDefault({
    Key? key,
    required this.imageUrl,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    required this.child,
    required this.progressHeight,
    required this.progressWidth,
  }) : super(key: key);

  final String imageUrl;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final Widget child;
  final double progressHeight;
  final double progressWidth;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: UniqueKey(),
      maxWidthDiskCache: maxWidthDiskCache, //optional
      maxHeightDiskCache: maxHeightDiskCache, //optional
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => child,
      progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
        height: progressHeight,
        width: progressWidth,
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
      errorWidget: (context, url, error) => Container(
        color: kBackgroundColor,
        child: const Icon(
          Icons.error,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
