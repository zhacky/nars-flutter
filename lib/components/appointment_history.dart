import 'package:nars/api/appointment_api.dart';
import 'package:nars/components/appointment_card.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/constants.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/appointment/get_appointment_by_patient_id_param.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/screens/appointment/appointment_screen.dart';
import 'package:nars/screens/appointments/appointments_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppointmentHistory extends StatefulWidget {
  const AppointmentHistory({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  final int patientId;

  @override
  State<AppointmentHistory> createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: defaultPadding / 2,
        ),
        SectionTitle(
          title: 'Appointment History',
          hasSeeAll: true,
          pressSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppointmentsScreen(),
              ),
            );
          },
        ),
        SizedBox(
          height: 212,
          child: FutureBuilder(
            future: AppointmentApi.getPatientAppointments(
              GetAppointmentByPatientIdParam(
                patientId: widget.patientId,
                pageCommon: PageCommon(
                  page: 1,
                  pageSize: 10,
                ),
                appointmentStatuses: [
                  0, //Pending
                  1, //WaitingForApproval
                  2, //Approved
                  3, //Ongoing
                  4, //Completed
                  5, //Cancelled
                  6, //Disapproved
                  7,
                  8,
                  9,
                ],
                userTypes: [
                  2,
                ],
              ),
            ),
            builder: (BuildContext context,
                AsyncSnapshot<List<Appointment>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data!;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right:
                                index == data.length - 1 ? 0 : defaultPadding,
                          ),
                          child: AppointmentCard(
                            width: 265,
                            appointment: data[index],
                            press: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentScreen(
                                    appointmentId: data[index].id,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(defaultBorderRadius),
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: List.generate(
        //         appointments.length,
        //         (index) => Padding(
        //           padding:
        //               EdgeInsets.only(right: index == 0 ? 0 : defaultPadding),
        //           child: DoctorCard(
        //             doctor: appointments[index].doctor,
        //             appointmentStatus:
        //                 getAppointmentStatusName(appointments[index].status),
        //             press: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => AppointmentScreen(
        //                     appointment: appointments[index],
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //         ),
        //       ).reversed.toList(),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
