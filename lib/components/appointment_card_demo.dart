import 'package:nars/components/label_default.dart';
import 'package:nars/components/text_pill.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCardDemo extends StatelessWidget {
  const AppointmentCardDemo({
    Key? key,
    required this.appointment,
    required this.press,
    this.showStatus = true,
    this.showPatient = false,
  }) : super(key: key);

  final AppointmentDemo appointment;
  final VoidCallback press;
  final bool showStatus, showPatient;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
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
              height: 182,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (showPatient ? '' : 'Dr. ') +
                              (showPatient
                                  ? appointment.profile.information.firstName +
                                      ' ' +
                                      appointment.profile.information.lastName
                                  : appointment.doctor.name),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        if (!showPatient)
                          Text(
                            appointment.doctor.specialty,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 11,
                            ),
                          ),
                        const SizedBox(height: defaultPadding),
                        Row(
                          children: [
                            Expanded(
                              child: LabelDefault(
                                header: 'Date',
                                text: DateFormat('MM/dd/yyyy')
                                    .format(appointment.dateTime),
                              ),
                            ),
                            Expanded(
                              child: LabelDefault(
                                header: 'Time',
                                text: DateFormat('h:mm a')
                                    .format(appointment.dateTime),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        // Text(
                        //   'Status',
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .subtitle2!
                        //       .copyWith(
                        //           fontWeight: FontWeight.normal,
                        //           color: Colors.black54),
                        // ),
                        // TextPill(
                        //   status: getAppointmentStatusName(appointment.status),
                        // ),
                        // const SizedBox(height: defaultPadding),
                        const LabelDefault(
                          header: 'Type',
                          text: 'Online',
                        ),
                        // Row(
                        //   children: [
                        //     const Expanded(
                        //       flex: 3,
                        //       child: LabelDefault(
                        //         header: 'Type',
                        //         text: 'Online',
                        //       ),
                        //     ),
                        //     if (showStatus)
                        //       Expanded(
                        //         flex: 7,
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               'Status',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .subtitle2!
                        //                   .copyWith(
                        //                       fontWeight: FontWeight.normal,
                        //                       color: Colors.black54),
                        //             ),
                        //             TextPill(
                        //               status: getAppointmentStatusName(
                        //                   appointment.status),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(width: defaultPadding / 2),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(defaultBorderRadius),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            showPatient
                                ? appointment
                                    .profile.information.profilePicture!
                                : appointment.doctor.image,
                          ),
                        ),
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
