import 'package:nars/components/doctor_long_card_demo.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/demo/doctor_demo.dart';
import 'package:flutter/material.dart';

class MyDoctorsScreen extends StatelessWidget {
  const MyDoctorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: defaultPadding,
          horizontal: Responsive.isDesktop(context)
              ? size.width * 0.30
              : defaultPadding,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            doctors.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                  bottom: index == doctors.length - 1 ? 0 : defaultPadding),
              child: DoctorLongCardDemo(
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
      ),
    );
  }
}
