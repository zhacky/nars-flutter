import 'package:nars/api/notification_api.dart';
import 'package:nars/components/bottom_nav_item.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/components/navigation_drawer_widget.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/screens/home/home_screen.dart';
import 'package:nars/screens/main/main_nurses_screen.dart';
import 'package:nars/screens/settings/settings_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPatientScreen extends StatefulWidget {
  const MainPatientScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainPatientScreenState createState() => _MainPatientScreenState();
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print("Message from background");
  print(message.notification!.title);
  print(message.notification!.body);
  // NotificationApi.showNotification(
  //     body: message.notification!.body, title: message.notification!.title);
}

class _MainPatientScreenState extends State<MainPatientScreen> {
  int currentIndex = 0;
  late List<Widget> _stack;

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String topic = "";

  void _update(int index) {
    setState(() => currentIndex = index);
  }

  Future<void> getName() async {
    print("TOPICz");
    print(topic);
    // FirebaseMessaging.instance.getInitialMessage().then((event) {
    //   if (event != null) {
    //     NotificationApi.showNotification(
    //         body: event.notification!.body, title: event.notification!.title);
    //   }
    //   setState(() {
    //     notificationMessage = "${event?.notification!.title} from foreground";
    //     _stack = [
    //       HomePage(update: _update),
    //     ];
    //   });
    //   print(notificationMessage);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   setState(() {
    //     NotificationApi.showNotification(
    //         body: event.notification!.body, title: event.notification!.title);
    //     notificationMessage = "${event.notification!.title} from background";
    //   });
    //   print(notificationMessage);
    // });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      topic = prefs.getString('name') == null ? "" : prefs.getString('name')!;
    });

    print("TOPICz");
    print(topic);
    if (!kIsWeb) {
      await NotificationApi.init();

      if (topic != "") await messaging.subscribeToTopic(topic);
    }

    // 3. O
  }

  @override
  void initState() {
    super.initState();
    _stack = [
      HomePage(update: _update),
    ];
    getName();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    Size size = MediaQuery.of(context).size;
    if (_stack.length == 1) {
      if (currentIndex != 0) {
        _stack.add(const MainNursesScreen());
        // _stack.add(
        //   const Center(
        //     child: Text(
        //       'Documents',
        //       style: TextStyle(fontSize: 60),
        //     ),
        //   ),
        // );
      }
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      endDrawer: const NavigationDrawerWidget(),
      appBar: Responsive.isDesktop(context)
          ? PreferredSize(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.30,
                  vertical: defaultPadding / 2,
                ),
                decoration: const BoxDecoration(color: kPrimaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/profile.svg',
                        color: Colors.white,
                      ),
                    ),
                    Image.asset(
                      'assets/images/logo.png', height: 60,
                      // height: MediaQuery.of(context).size.height * 0.4, //40%
                      // fit: BoxFit.cover,
                    ),
                    Builder(
                      builder: (context) => Padding(
                        padding:
                            const EdgeInsets.only(right: defaultPadding / 2),
                        child: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/menu5.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              preferredSize: Size(
                size.width,
                56,
              ),
            )
          : AppBar(
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  'assets/icons/profile.svg',
                  color: Colors.white,
                ),
              ),
              title: Image.asset(
                'assets/images/logo.png', height: 60,
                // height: MediaQuery.of(context).size.height * 0.4, //40%
                // fit: BoxFit.cover,
              ),
              actions: [
                Builder(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.only(right: defaultPadding / 2),
                    child: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/menu5.svg',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      body: IndexedStack(
        index: currentIndex,
        children: _stack,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: primaryColor,
      //   // unselectedItemColor: Colors.white70,
      //   // selectedFontSize: 16,
      //   // unselectedFontSize: 0,
      //   showUnselectedLabels: false,
      //   currentIndex: currentIndex,
      //   onTap: (index) => setState(() => currentIndex = index),
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Container(
      //         width: 20,
      //         height: 20,
      //         child: SvgPicture.asset("assets/icons/home2.svg"),
      //       ),
      //       label: "Home",
      //       // backgroundColor: primaryColor,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Container(
      //         width: 20,
      //         height: 20,
      //         child: SvgPicture.asset("assets/icons/doctor.svg"),
      //       ),
      //       label: "Doctors",
      //       // backgroundColor: Colors.redAccent,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Container(
      //         width: 20,
      //         height: 20,
      //         child: SvgPicture.asset("assets/icons/clipboard5.svg"),
      //       ),
      //       label: "Appointments",
      //       // backgroundColor: Colors.yellowAccent,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Container(
      //         width: 20,
      //         height: 20,
      //         child: SvgPicture.asset("assets/icons/profile.svg"),
      //       ),
      //       label: "Profile",
      //       // backgroundColor: Colors.greenAccent,
      //     ),
      //   ],
      // ),

      bottomNavigationBar: CardContainer(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isDesktop(context) ? size.width * 0.5 : 50,
        ),
        height: 60,
        borderRadius: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BottomNavItem(
              title: 'Home',
              svgScr: 'assets/icons/home2.svg',
              press: () {
                // const message = 'Button Notifications';
                // const snackBar = SnackBar(
                //   content: Text(
                //     message,
                //     style: TextStyle(
                //       fontSize: 20,
                //     ),
                //   ),
                //   backgroundColor: Colors.green,
                // );
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                setState(() => currentIndex = 0);
              },
              isActive: currentIndex == 0,
            ),
            BottomNavItem(
              title: 'Nurses',
              svgScr: 'assets/icons/nurse.svg',
              press: () {
                setState(() => currentIndex = 1);
              },
              isActive: currentIndex == 1,
            ),
            // BottomNavItem(
            //   title: 'Documents',
            //   svgScr: 'assets/icons/clipboard5.svg',
            //   press: () {
            //     setState(() => currentIndex = 3);
            //   },
            //   isActive: currentIndex == 3,
            // ),
          ],
        ),
      ),

      // Animated Bottom Nav Bar
      // bottomNavigationBar: Container(
      //   height: 60,
      //   decoration: const BoxDecoration(
      //     color: Colors.white,
      //   ),
      //   child: ListView.builder(
      //     itemCount: 4,
      //     scrollDirection: Axis.horizontal,
      //     padding: const EdgeInsets.symmetric(
      //       horizontal: 20,
      //     ),
      //     itemBuilder: (context, index) => InkWell(
      //       onTap: () {
      //         setState(() {
      //           currentIndex = index;
      //         });
      //       },
      //       splashColor: Colors.transparent,
      //       highlightColor: Colors.transparent,
      //       child: Stack(
      //         children: [
      //           AnimatedContainer(
      //             duration: const Duration(seconds: 1),
      //             curve: Curves.fastLinearToSlowEaseIn,
      //             width: index == currentIndex
      //                 ? displayWidth * .32
      //                 : displayWidth * .18,
      //             alignment: Alignment.center,
      //             child: AnimatedContainer(
      //               duration: const Duration(seconds: 1),
      //               curve: Curves.fastLinearToSlowEaseIn,
      //               height: index == currentIndex ? displayWidth * .12 : 0,
      //               width: index == currentIndex ? displayWidth * .32 : 0,
      //               decoration: BoxDecoration(
      //                 color: index == currentIndex
      //                     ? primaryColor
      //                     : Colors.transparent,
      //                 borderRadius: BorderRadius.circular(defaultBorderRadius),
      //               ),
      //             ),
      //           ),
      //           AnimatedContainer(
      //             duration: const Duration(seconds: 1),
      //             curve: Curves.fastLinearToSlowEaseIn,
      //             width: index == currentIndex
      //                 ? displayWidth * .36
      //                 : displayWidth * .18,
      //             alignment: Alignment.center,
      //             child: Stack(
      //               children: [
      //                 Row(
      //                   children: [
      //                     AnimatedContainer(
      //                       duration: const Duration(seconds: 1),
      //                       curve: Curves.fastLinearToSlowEaseIn,
      //                       width:
      //                           index == currentIndex ? displayWidth * .11 : 0,
      //                     ),
      //                     AnimatedOpacity(
      //                       opacity: index == currentIndex ? 1 : 0,
      //                       duration: const Duration(seconds: 1),
      //                       curve: Curves.fastLinearToSlowEaseIn,
      //                       child: Text(
      //                         index == currentIndex ? listOfStrings[index] : '',
      //                         style: Theme.of(context)
      //                             .textTheme
      //                             .subtitle2!
      //                             .copyWith(
      //                               color: Colors.white,
      //                               fontWeight: FontWeight.w500,
      //                             ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Row(
      //                   children: [
      //                     AnimatedContainer(
      //                       duration: const Duration(seconds: 1),
      //                       curve: Curves.fastLinearToSlowEaseIn,
      //                       width:
      //                           index == currentIndex ? displayWidth * .02 : 20,
      //                     ),
      //                     Icon(
      //                       listOfIcons[index],
      //                       size: displayWidth * .076,
      //                       color: index == currentIndex
      //                           ? Colors.white
      //                           : Colors.black,
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  // List<String> listOfStrings = [
  //   'Home',
  //   'Doctors',
  //   'Nurses',
  //   'Documents',
  // ];

  // List<IconData> listOfIcons = [
  //   Icons.home_rounded,
  //   Icons.favorite_rounded,
  //   Icons.settings_rounded,
  //   Icons.person_rounded,
  // ];
}
