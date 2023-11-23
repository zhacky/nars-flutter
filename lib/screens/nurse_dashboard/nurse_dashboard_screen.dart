import 'package:nars/components/appointment_card_demo.dart';
import 'package:nars/components/subtitle.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/appointment_status.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/patient/profile.dart';
import 'package:nars/screens/appointment/appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NurseDashboardScreen extends StatefulWidget {
  const NurseDashboardScreen({
    Key? key,
    required this.update,
  }) : super(key: key);

  final ValueChanged<int> update;

  @override
  _NurseDashboardScreenState createState() => _NurseDashboardScreenState();
}

class _NurseDashboardScreenState extends State<NurseDashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _appointments = appointments
        .where((x) => x.status == AppointmentStatusDemo.WaitingForApproval)
        .toList();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello Nurse", style: TextStyle(fontSize: 20)),
            Text(
              profiles[0].information.firstName +
                  ' ' +
                  profiles[0].information.lastName,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 30,
                  ),
            ),
            const SizedBox(height: defaultPadding),
            SizedBox(
              width: size.width,
              child: Row(
                children: const [
                  DashboardCard(
                    title: 'For Approval',
                    value: '3',
                    svgScr: 'assets/icons/inspect.svg',
                  ),
                  SizedBox(width: defaultPadding),
                  DashboardCard(
                    title: 'Pending',
                    value: '2',
                    svgScr: 'assets/icons/hourglass.svg',
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            SizedBox(
              width: size.width,
              child: Row(
                children: const [
                  DashboardCard(
                    title: 'Completed',
                    value: '6',
                    svgScr: 'assets/icons/completed.svg',
                  ),
                  SizedBox(width: defaultPadding),
                  DashboardCard(
                    title: 'Appointments',
                    value: '8',
                    svgScr: 'assets/icons/appointment.svg',
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'For Approvals'),
            const SizedBox(height: defaultPadding),
            Column(
              children: List.generate(
                _appointments.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index == _appointments.length - 1 ? 0 : defaultPadding,
                  ),
                  child: AppointmentCardDemo(
                    appointment: _appointments[index],
                    showStatus: false,
                    showPatient: true,
                    press: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AppointmentScreen(
                      //       appointment: _appointments[index],
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
    required this.svgScr,
  }) : super(key: key);

  final String title, value, svgScr;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              splashColor: kPrimaryColor.withOpacity(0.3),
              highlightColor: Colors.transparent,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      svgScr,
                      width: 35,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(width: defaultPadding),
                    RichText(
                      text: TextSpan(
                        text: title + '\n',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                value,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
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
      ),
    );
  }
}
