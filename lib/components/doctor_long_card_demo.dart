import 'package:nars/constants.dart';
import 'package:nars/models/demo/doctor_demo.dart';
import 'package:flutter/material.dart';

import 'doctor_card_experience.dart';

class DoctorLongCardDemo extends StatelessWidget {
  const DoctorLongCardDemo({
    Key? key,
    required this.doctor,
    required this.press,
    this.borderRadius = true,
  }) : super(key: key);

  final Doctor doctor;
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
              height: 156,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Row(
                          children: List.generate(
                            doctor.specializations.length,
                            (index) => Text(
                              doctor.specializations[index].title +
                                  (index == doctor.specializations.length - 1
                                      ? ''
                                      : ', '),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        // Text(
                        //   doctor.specialty + ' (' + doctor.title + ')',
                        //   style: const TextStyle(
                        //     color: Colors.black54,
                        //     fontSize: 11,
                        //   ),
                        // ),
                        const SizedBox(height: defaultPadding * 0.5),
                        Text(
                          doctor.hospital.title,
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                        ),
                        Text(
                          doctor.hospital.address.fullAddress,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                        // Rating(
                        //   rating: doctor.rating,
                        // ),
                        // const SizedBox(
                        //   height: defaultPadding,
                        // ),
                        // const Spacer(),
                        const SizedBox(height: defaultPadding * 0.5),
                        Text(
                          doctor.days,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          doctor.openTime.format(context) +
                              ' - ' +
                              doctor.closeTime.format(context),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: defaultPadding * .5),
                        DoctorCardExperience(experience: doctor.experience),
                        // const SizedBox(
                        //   height: defaultPadding / 2,
                        // ),
                        // DoctorCardPatient(
                        //     label: 'Patient', amount: doctor.patient),
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
                        fit: BoxFit.cover,
                        image: AssetImage(doctor.image),
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
