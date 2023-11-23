import 'package:nars/components/doctor_card.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/constants.dart';
import 'package:nars/models/demo/doctor_demo.dart';
import 'package:nars/screens/doctor_detail/doctor_detail_screen.dart';
import 'package:flutter/material.dart';

class AvailableDoctors extends StatelessWidget {
  const AvailableDoctors({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding / 2),
        SectionTitle(
          title: "Available Doctors",
          pressSeeAll: () {},
        ),
        const SizedBox(height: defaultPadding),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              doctors.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: defaultPadding),
                child: DoctorCard(
                  doctor: doctors[index],
                  press: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => DoctorDetailScreen(
                    //       doctor: doctors[index],
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
