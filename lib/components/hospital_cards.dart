import 'package:nars/components/card_asset_image.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/constants.dart';
import 'package:nars/models/demo/hospital_demo.dart';
import 'package:flutter/material.dart';

class HospitalCards extends StatelessWidget {
  const HospitalCards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "Hospitals",
          hasSeeAll: true,
          pressSeeAll: () {},
        ),
        // const SizedBox(height: defaultPadding),
        ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                hospitals.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                      right:
                          index == hospitals.length - 1 ? 0 : defaultPadding),
                  child: SizedBox(
                    width: 170,
                    height: 80,
                    child: CardAssetImage(
                      imageScr: '',
                      title: hospitals[index].title,
                      boxFit: BoxFit.contain,
                      press: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
