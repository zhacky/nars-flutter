import 'package:nars/components/rating.dart';
import 'package:nars/constants.dart';
import 'package:nars/models/demo/nurse_demo.dart';
import 'package:flutter/material.dart';

import 'doctor_card_experience.dart';
import 'doctor_card_patient.dart';

class NurseLongCard extends StatelessWidget {
  const NurseLongCard({
    Key? key,
    required this.nurse,
    required this.press,
    this.borderRadius = true,
  }) : super(key: key);

  final Nurse nurse;
  final VoidCallback press;
  final bool borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(borderRadius ? defaultBorderRadius : 0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          splashColor: kPrimaryColor.withOpacity(0.3),
          highlightColor: Colors.transparent,
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SizedBox(
              height: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nurse.name,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          nurse.specialty + ' (' + nurse.title + ')',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding / 4,
                        ),
                        Rating(
                          rating: nurse.rating,
                        ),
                        // const SizedBox(
                        //   height: defaultPadding,
                        // ),
                        const Spacer(),
                        DoctorCardExperience(experience: nurse.experience),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        DoctorCardPatient(
                            label: 'Patient', amount: nurse.patient),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadius),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage(nurse.image),
                      ),
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
