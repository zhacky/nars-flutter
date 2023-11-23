import 'package:nars/components/card_container.dart';
import 'package:nars/components/label_default.dart';
import 'package:nars/components/text_pill.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  AppointmentCard({
    Key? key,
    required this.appointment,
    this.press,
    this.height,
    this.width,
    this.showStatus = true,
    this.showPatient = false,
  }) : super(key: key);

  final Appointment appointment;
  final VoidCallback? press;
  final double? height;
  final double? width;
  final bool showStatus, showPatient;
  late bool isNurse = appointment.nurseAppointmentDetail != null;

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
              height: height,
              width: width,
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
                          (appointment.practitionerId == null && !showPatient
                                  ? 'Waiting for a Nurse'
                                  : showPatient || isNurse
                                      ? ''
                                      : 'Dr. ') +
                              (showPatient
                                  ? appointment.patientName!
                                  : appointment.practitionerName!),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        if (!showPatient)
                          Wrap(
                            children: List.generate(
                              appointment.specialization!.length,
                              (index) => Text(
                                appointment.specialization![index] +
                                    (index ==
                                            appointment.specialization!.length -
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
                        const SizedBox(height: defaultPadding * .5),
                        Row(
                          children: [
                            Expanded(
                              child: LabelDefault(
                                header: 'Date',
                                text: DateFormat('MM/dd/yyyy')
                                    .format(appointment.schedule),
                              ),
                            ),
                            const SizedBox(width: defaultPadding * .5),
                            Expanded(
                              child: LabelDefault(
                                header: 'Time',
                                text: DateFormat('h:mm a')
                                    .format(appointment.schedule),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding * .5),
                        Text(
                          'Status',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54),
                        ),
                        TextPill(
                          status: appointmentHistoryLabel(
                              appointment.appointmentStatus.name),
                        ),
                        const SizedBox(height: defaultPadding * .5),
                        LabelDefault(
                          header: 'Type',
                          text: isNurse
                              ? 'Home Service'
                              : appointment.bookingType,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: defaultPadding / 2),
                  Expanded(
                    flex: 4,
                    child: CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl: showPatient
                          ? appointment.patientProfilePicture!
                          : appointment.practitionerProfilePicture!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(defaultBorderRadius),
                          ),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider),
                        ),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => CardContainer(
                        width: 265,
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
