import 'package:nars/components/card_container.dart';
import 'package:nars/constants.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'doctor_card_experience.dart';

class DoctorLongCard extends StatelessWidget {
  const DoctorLongCard({
    Key? key,
    required this.practitioner,
    required this.press,
    this.borderRadius = true,
  }) : super(key: key);

  final Practitioner practitioner;
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
                          'Dr. ' + practitioner.fullName!,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        if (practitioner.specialization != null)
                          Wrap(
                            children: List.generate(
                              practitioner.specialization!.length,
                              (index) => Text(
                                practitioner.specialization![index].name +
                                    (index ==
                                            practitioner
                                                    .specialization!.length -
                                                1
                                        ? ''
                                        : ', '),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        if (practitioner.practitionerScheduleHospitals !=
                            null) ...[
                          const SizedBox(height: defaultPadding),
                          Wrap(
                            children: List.generate(
                              practitioner
                                  .practitionerScheduleHospitals!.length,
                              (index) => Text(
                                practitioner
                                        .practitionerScheduleHospitals![index]
                                        .hospitalName! +
                                    (index ==
                                            practitioner
                                                    .practitionerScheduleHospitals!
                                                    .length -
                                                1
                                        ? ''
                                        : ', '),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],

                        // const SizedBox(height: defaultPadding * 0.5),
                        // Text(
                        //   practitioner.hospital.title,
                        //   style:
                        //       Theme.of(context).textTheme.subtitle2!.copyWith(
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: 12,
                        //           ),
                        // ),
                        // Text(
                        //   doctor.hospital.address.fullAddress,
                        //   style: const TextStyle(
                        //     color: Colors.black54,
                        //     fontSize: 11,
                        //   ),
                        // ),
                        // Rating(
                        //   rating: doctor.rating,
                        // ),
                        // const SizedBox(
                        //   height: defaultPadding,
                        // ),
                        // const Spacer(),
                        // const SizedBox(height: defaultPadding * 0.5),
                        // Text(
                        //   doctor.days,
                        //   style: const TextStyle(
                        //     color: Colors.black87,
                        //     fontSize: 12,
                        //   ),
                        // ),
                        // Text(
                        //   doctor.openTime.format(context) +
                        //       ' - ' +
                        //       doctor.closeTime.format(context),
                        //   style: const TextStyle(
                        //     color: Colors.black87,
                        //     fontSize: 12,
                        //   ),
                        // ),
                        const SizedBox(height: defaultPadding * .5),
                        DoctorCardExperience(
                            experience: practitioner.yearOfExperience!),
                        // const SizedBox(
                        //   height: defaultPadding / 2,
                        // ),
                        // DoctorCardPatient(
                        //     label: 'Patient', amount: doctor.patient),
                      ],
                    ),
                  ),
                  CachedNetworkImage(
                    key: UniqueKey(),
                    maxWidthDiskCache: 200,
                    imageUrl: practitioner.profilePicture!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(defaultBorderRadius),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => CardContainer(
                      // width: 265,
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
                    errorWidget: (context, url, error) => Container(
                      color: kBackgroundColor,
                      child: const Icon(
                        Icons.error,
                        color: Colors.redAccent,
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
