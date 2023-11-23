import 'package:nars/components/app_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryWidget extends StatefulWidget {
  GalleryWidget({
    Key? key,
    required this.urlImages,
    this.index = 0,
  })  : pageController = PageController(initialPage: index),
        super(key: key);

  final PageController pageController;
  final List<String> urlImages;
  final int index;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  late int index = widget.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Gallery'),
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          PhotoViewGallery.builder(
            pageController: widget.pageController,
            itemCount: widget.urlImages.length,
            builder: (context, index) {
              final urlImage = widget.urlImages[index];

              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                  urlImage,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 4,
              );
            },
            onPageChanged: (index) => setState(() => this.index = index),
          ),
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              'Image ${index + 1}/${widget.urlImages.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
