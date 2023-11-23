import 'package:nars/components/appbar_nav_item.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/screens/appointments/appointments_screen.dart';
import 'package:nars/screens/make_appointment/make_appointment_screen.dart';
import 'package:flutter/material.dart';

class MainNursesScreen extends StatefulWidget {
  const MainNursesScreen({Key? key}) : super(key: key);

  @override
  _MainNursesScreenState createState() => _MainNursesScreenState();
}

class _MainNursesScreenState extends State<MainNursesScreen> {
  int currentIndex = 0;

  // void _update(int index) {
  //   setState(() => currentIndex = index);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? PreferredSize(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: defaultPadding / 2,
                  horizontal: size.width * 0.30,
                ),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBarNavItem(
                      title: 'Book a Nurse',
                      //svgScr: 'assets/icons/nurse.svg',
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MakeAppointmentScreen(),
                          ),
                        );
                      },
                      // isActive: currentIndex == 1,
                    ),
                    AppBarNavItem(
                      title: 'Appointments',
                      press: () {
                        setState(() => currentIndex = 0);
                        // const FindDoctorScreen().method();
                      },
                      isActive: currentIndex == 0,
                    ),
                    // AppBarNavItem(
                    //   title: 'My Nurses',
                    //   svgScr: 'assets/icons/doctor.svg',
                    //   press: () {
                    //     setState(() => currentIndex = 1);
                    //   },
                    //   isActive: currentIndex == 1,
                    // ),
                  ],
                ),
              ),
              preferredSize: Size(
                size.width,
                57,
              ),
            )
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              // titleSpacing: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppBarNavItem(
                    title: 'Book a Nurse',
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MakeAppointmentScreen(),
                        ),
                      );
                    },
                    // isActive: currentIndex == 1,
                  ),
                  AppBarNavItem(
                    title: 'Appointments',
                    press: () {
                      setState(() => currentIndex = 0);
                      // const FindDoctorScreen().method();
                    },
                    isActive: currentIndex == 0,
                  ),
                  // AppBarNavItem(
                  //   title: 'My Nurses',
                  //   svgScr: 'assets/icons/doctor.svg',
                  //   press: () {
                  //     setState(() => currentIndex = 1);
                  //   },
                  //   isActive: currentIndex == 1,
                  // ),
                ],
              ),
            ),
      body: IndexedStack(
        index: currentIndex,
        children: const [
          // MyDoctorsScreen(),
          AppointmentsScreen(
            forNurse: true,
          ),
        ],
      ),
    );
  }
}
