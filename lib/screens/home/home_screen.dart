import 'package:nars/api/appointment_api.dart';
import 'package:nars/api/user_api.dart';
import 'package:nars/components/appointment_card.dart';

import 'package:nars/api/notification_api.dart';
import 'package:nars/components/carousel.dart';
import 'package:nars/components/search_form.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/components/service_card.dart';
import 'package:nars/components/subtitle.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/appointment/get_appointment_by_patient_id_param.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:nars/screens/appointment/appointment_screen.dart';
import 'package:nars/screens/appointments/appointments_screen.dart';
import 'package:nars/screens/make_appointment/make_appointment_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.update,
  }) : super(key: key);

  final ValueChanged<int> update;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _profile = TokenPreferences.getProfileId()!;
  late Stream<List<Appointment>> appointmentsStream;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> getName() async {
    var user = await UserApi.getUserData();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var topic = prefs.getString('name') == null ? "" : prefs.getString('name')!;

    print("Topics subscribed:");
    print(topic); // debugging. remove before prod.
    if (!kIsWeb) {
      await NotificationApi.init();
      FirebaseMessaging.onMessage.listen((event) async {
        NotificationApi.showNotification(
            body: event.notification!.body, title: event.notification!.title);

        setState(() {});
        print("FirebaseMessaging.onMessage should've fired by now"); // debugging. remove before prod.
      });

      if (topic != "") await messaging.subscribeToTopic(topic);
      await messaging.subscribeToTopic(user.userType.name);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }
  // late Information information;

  Stream<List<Appointment>> getAppointments() async* {
    yield await AppointmentApi.getPatientAppointments(
      GetAppointmentByPatientIdParam(
        patientId: _profile,
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
          8, //ReschedByPractitioner
          9, //ReschedByPatient
        ],
        userTypes: [
          2,
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    appointmentsStream = getAppointments();

    return Scaffold(
      backgroundColor: kBackgroundColor,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Carousel(),
              const SizedBox(height: defaultPadding),
              GestureDetector(
                onTap: () {
                  widget.update(1);
                },
                child: const AbsorbPointer(
                  child: SearchForm(),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const SubtitleDefault(
                  title:
                      'Request for a Nurse or a Home Service?'),
              const SizedBox(height: defaultPadding),
              Wrap(
                spacing: defaultPadding,
                runSpacing: defaultPadding,
                children: <Widget>[
                  ServiceCard(
                    title: 'Nurse\n ',
                    imgScr: 'assets/images/nursetile.png',
                    columns: 2,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MakeAppointmentScreen(),
                        ),
                      );
                    },
                  ),
                  ServiceCard(
                    title: 'Caregiver\n(Coming Soon)',
                    imgScr: 'assets/images/caregivertile.png',
                    columns: 2,
                    onTap: () async {
                      if(!kIsWeb) {
                        await NotificationApi.init();
                        NotificationApi.showNotification(
                          title: 'Coming Soon!',
                          body: 'This feature is coming soon.',
                        );
                      }
                    },
                  ),
                  ServiceCard(
                    title: 'Midwife\n(Coming Soon)',
                    imgScr: 'assets/images/midwifetile.png',
                    columns: 2,
                    onTap: () async {
                      if(!kIsWeb) {
                        await NotificationApi.init();
                        NotificationApi.showNotification(
                          title: 'Coming Soon!',
                          body: 'This feature is coming soon.',
                        );
                      }
                    },
                  ),
                ], // ServiceCard ends before this line
              ),
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
                      builder: (context) => const AppointmentsScreen(
                        hasAppbar: true,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 213,
                child: StreamBuilder(
                  stream: appointmentsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Appointment>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<Appointment> data = snapshot.data!;
                      return ClipRRect(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
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
                                  right: index == data.length - 1
                                      ? 0
                                      : defaultPadding,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
