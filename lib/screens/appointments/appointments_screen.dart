import 'package:nars/api/appointment_api.dart';
import 'package:nars/api/auth_service.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/appointment_card.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/appointment/get_appointment_by_patient_id_param.dart';
import 'package:nars/models/appointment/get_appointment_by_practitioner_id_param.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:nars/screens/appointment/appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({
    Key? key,
    this.hasAppbar = false,
    this.forNurse = false,
  }) : super(key: key);

  final bool hasAppbar;
  final bool forNurse;

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final flavor = Provider.of<Flavor>(context);
    final user = Provider.of<AuthService>(context).currentUser!;
    int? _profile;
    if (flavor == Flavor.Patient) {
      _profile = TokenPreferences.getProfileId()!;
    }

    return Scaffold(
      appBar: widget.hasAppbar ? AppBarDefault(title: 'Appointments') : null,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
            horizontal: Responsive.isDesktop(context)
                ? size.width * 0.30
                : defaultPadding,
          ),
          child: FutureBuilder(
            future: flavor == Flavor.Patient
                ? AppointmentApi.getPatientAppointments(
                    GetAppointmentByPatientIdParam(
                      patientId: _profile!,
                      pageCommon: PageCommon(
                        page: 1,
                        pageSize: 1000,
                      ),
                      appointmentStatuses: [
                        0, //Pending
                        1, //WaitingForApproval
                        2, //Approved
                        3, //Ongoing
                        4, //Completed
                        5, //Cancelled
                        6, //Disapproved
                        8, //ReschedByPractitioner
                        9, //ReschedByPatient
                      ],
                      userTypes: [
                        (widget.forNurse ? 3 : 2),
                      ],
                    ),
                  )
                : AppointmentApi.getPractitionerAppointments(
                    GetAppointmentByPractitionerIdParam(
                      practitionerId: user.id,
                      pageCommon: PageCommon(
                        page: 1,
                        pageSize: 0,
                      ),
                      appointmentStatuses: [
                        1, //WaitingForApproval
                        2, //Approved
                        3, //Ongoing
                        4, //Completed
                        5, //Cancelled
                        6, //Disapproved
                        8, //ReschedByPractitioner
                        9, //ReschedByPatient
                      ],
                      isDescending: true,
                    ),
                  ),
            builder: (BuildContext context,
                AsyncSnapshot<List<Appointment>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data!;
                if (data.isNotEmpty) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      // scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: index == data.length - 1
                                  ? 0
                                  : defaultPadding),
                          child: AppointmentCard(
                            height: 180,
                            appointment: data[index],
                            showPatient: flavor != Flavor.Patient,
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
                  );
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: defaultPadding),
                      child: Text(
                        'No appointments yet',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
            },
          ),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: List.generate(
          //     _appointments.length,
          //     (index) => Padding(
          //       padding: EdgeInsets.only(bottom: index == 0 ? 0 : defaultPadding),
          //       child: AppointmentCardDemo(
          //         showPatient: flavor != Flavor.Patient,
          //         appointment: _appointments[index],
          //         press: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => AppointmentScreen(
          //                 appointment: _appointments[index],
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ).reversed.toList(),
          // ),
        ),
      ),
    );
  }
}
