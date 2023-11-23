import 'package:nars/components/appbar_nav_item.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/screens/appointments/appointments_screen.dart';
import 'package:nars/screens/find_doctor/find_doctor_screen.dart';
import 'package:flutter/material.dart';

class MainDoctorsScreen extends StatefulWidget {
  const MainDoctorsScreen({
    Key? key,
    required this.update,
  }) : super(key: key);

  final ValueChanged<int> update;

  @override
  _MainDoctorsScreenState createState() => _MainDoctorsScreenState();
}

class _MainDoctorsScreenState extends State<MainDoctorsScreen> {
  int currentIndex = 0;

  void _update(int index) {
    setState(() => widget.update(index));
  }

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
                      title: 'Find a Doctor',
                      svgScr: 'assets/icons/doctor.svg',
                      press: () {
                        setState(() => currentIndex = 0);
                        // const FindDoctorScreen().method();
                      },
                      isActive: currentIndex == 0,
                    ),
                    AppBarNavItem(
                      title: 'Appointments',
                      svgScr: 'assets/icons/doctor.svg',
                      press: () {
                        setState(() => currentIndex = 1);
                      },
                      isActive: currentIndex == 1,
                    ),
                    // AppBarNavItem(
                    //   title: 'My Doctors',
                    //   svgScr: 'assets/icons/doctor.svg',
                    //   press: () {
                    //     setState(() => currentIndex = 2);
                    //   },
                    //   isActive: currentIndex == 2,
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
                    title: 'Find a Doctor',
                    svgScr: 'assets/icons/doctor.svg',
                    press: () {
                      setState(() => currentIndex = 0);
                      // const FindDoctorScreen().method();
                    },
                    isActive: currentIndex == 0,
                  ),
                  AppBarNavItem(
                    title: 'Appointments',
                    svgScr: 'assets/icons/doctor.svg',
                    press: () {
                      setState(() => currentIndex = 1);
                    },
                    isActive: currentIndex == 1,
                  ),
                  // AppBarNavItem(
                  //   title: 'My Doctors',
                  //   svgScr: 'assets/icons/doctor.svg',
                  //   press: () {
                  //     setState(() => currentIndex = 2);
                  //   },
                  //   isActive: currentIndex == 2,
                  // ),
                ],
              ),
            ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          FindDoctorScreen(update: _update),
          const AppointmentsScreen(),
          // const MyDoctorsScreen(),
        ],
      ),
    );
  }
}
