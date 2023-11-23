import 'package:nars/api/banner_api.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/banner/banner_photo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  const Carousel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      child: SizedBox(
        height: MediaQuery.of(context).size.height *
            (Responsive.isDesktop(context) ? 0.33 : 0.21),
        child: FutureBuilder(
          future: BannerApi.getBanners(),
          builder: (BuildContext context,
              AsyncSnapshot<List<BannerPhoto>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data!;
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl: data[index].imageLink,
                      imageBuilder: (context, imageProvider) => CardContainer(
                        margin: EdgeInsets.only(
                            right:
                                index == data.length - 1 ? 0 : defaultPadding),
                        width: MediaQuery.of(context).size.width *
                            (Responsive.isDesktop(context) ? 0.3 : 0.8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => CardContainer(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.only(right: defaultPadding),
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
                    );
                  },
                ),
              );
            } else {
              return CardContainer(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
    // Column(
    //   children: [
    //     SingleChildScrollView(
    //       scrollDirection: Axis.horizontal,
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: List.generate(
    //           banners.length,
    //           (index) => Padding(
    //             padding: const EdgeInsets.only(right: defaultPadding),
    //             child: GestureDetector(
    //               onTap: () {},
    //               child: CardContainer(
    //                 width: MediaQuery.of(context).size.width * 0.8,
    //                 height: MediaQuery.of(context).size.width * 0.45,
    //                 image: DecorationImage(
    //                   fit: BoxFit.fitWidth,
    //                   image: AssetImage(banners[index].imgScr),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}
