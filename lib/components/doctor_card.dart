import 'package:nars/components/doctor_card_experience.dart';
import 'package:nars/components/doctor_card_patient.dart';
import 'package:nars/components/rating.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/models/demo/doctor_demo.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.press,
    this.appointmentStatus,
  }) : super(key: key);

  final Doctor doctor;
  final String? appointmentStatus;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      child: Container(
        width: 250,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            splashColor: kPrimaryColor.withOpacity(0.3),
            highlightColor: Colors.transparent,
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Text(
                              doctor.specialty,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(
                              height: defaultPadding / 4,
                            ),
                            Rating(
                              rating: doctor.rating,
                            ),
                            // const SizedBox(
                            //   height: defaultPadding,
                            // ),
                            const Spacer(),
                            DoctorCardExperience(experience: doctor.experience),
                            const SizedBox(
                              height: defaultPadding / 2,
                            ),
                            DoctorCardPatient(
                                label: 'Patient', amount: doctor.patient),
                          ],
                        ),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(defaultBorderRadius),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage(doctor.image),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: appointmentStatus != 'Resched Requested'
                          ? kPrimaryColor
                          : Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appointHistoryCardButtonTxt(appointmentStatus),
                          style: const TextStyle(
                            // fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
