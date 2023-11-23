import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/components/doctor_card_experience.dart';
import 'package:nars/components/doctor_card_patient.dart';
import 'package:nars/components/rating.dart';
import 'package:nars/constants.dart';
import 'package:nars/models/demo/nurse_demo.dart';
import 'package:nars/screens/make_appointment/make_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NurseDetailScreen extends StatelessWidget {
  const NurseDetailScreen({
    Key? key,
    required this.nurse,
  }) : super(key: key);

  // final bool heart = false;
  final Nurse nurse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: nurse.name,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/heart2.svg",
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Image.asset(
            nurse.image,
            height: MediaQuery.of(context).size.height * 0.4, //40%
            fit: BoxFit.cover,
          ),
          Expanded(
            child: CardContainer(
              padding: const EdgeInsets.fromLTRB(
                  defaultPadding, defaultPadding * 2, defaultPadding, 0),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius * 2),
                topRight: Radius.circular(defaultBorderRadius * 2),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          nurse.specialty,
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          nurse.title,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding / 4,
                    ),
                    Row(
                      children: [
                        Rating(rating: nurse.rating),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Text(
                        nurse.description,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: defaultPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DoctorCardPatient(
                              label: 'Patient', amount: nurse.patient),
                          DoctorCardExperience(experience: nurse.experience),
                          DoctorCardPatient(
                              label: 'Reviews', amount: nurse.patient),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CardContainer(
        borderRadius: null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: Material(
            color: kPrimaryColor,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MakeAppointmentScreen(),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: const Text(
                  "Book an Appointment",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
