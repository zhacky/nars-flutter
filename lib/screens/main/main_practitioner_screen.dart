import 'package:nars/api/notification_api.dart';
import 'package:nars/components/bottom_nav_item.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/components/navigation_drawer_widget.dart';
import 'package:nars/constants.dart';
import 'package:nars/firebase_options.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/screens/appointments/appointments_screen.dart';
import 'package:nars/screens/doctor_dashboard/doctor_dashboard_screen.dart';
import 'package:nars/screens/settings/settings_screen.dart';
import 'package:nars/screens/wallet/wallet_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPractitionerScreen extends StatefulWidget {
  const MainPractitionerScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainPractitionerScreenState createState() => _MainPractitionerScreenState();
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print("Message from background");
  NotificationApi.showNotification(
      body: message.notification!.body, title: message.notification!.title);
}

class _MainPractitionerScreenState extends State<MainPractitionerScreen> {
  int currentIndex = 0;
  late List<Widget> _stack;
  String notificationMessage = "";

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String topic = "";
  void _update(int index) {
    setState(() => currentIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _stack = [
      DoctorDashboardScreen(update: _update),
    ];
    // getName();
  }

  // Future<void> getName() async {
  //   NotificationApi.init();
  //   // NotificationSettings settings = await messaging.requestPermission(
  //   //   alert: true,
  //   //   announcement: false,
  //   //   badge: true,
  //   //   carPlay: false,
  //   //   criticalAlert: true,
  //   //   provisional: true,
  //   //   sound: true,
  //   // );
  //   print("TOPICz");
  //   print(topic);

  //   FirebaseMessaging.onMessage.listen((event) async {
  //     NotificationApi.showNotification(
  //         body: event.notification!.body, title: event.notification!.title);

  //     setState(() {});
  //     print("onMessage");
  //   });
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true, // Required to display a heads up notification
    //   badge: true,
    //   sound: true,
    // );

    // FirebaseMessaging.instance.getInitialMessage().then((event) async {
    //   if (event != null) {
    //     await NotificationApi.showNotification(
    //         body: event.notification!.body, title: event.notification!.title);
    //   }
    //   setState(() {
    //     notificationMessage = "${event?.notification!.title} from foreground";
    //   });
    //   print(notificationMessage);
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   NotificationApi.showNotification(
    //       body: event.notification!.body, title: event.notification!.title);
    //   setState(() {
    //     notificationMessage = "${event.notification!.title} from background";
    //   });
    //   print(notificationMessage);
    // });
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     topic = prefs.getString('name') == null ? "" : prefs.getString('name')!;
  //   });

  //   print("TOPICz");
  //   print(topic);
  //   if (topic != "" && !kIsWeb) await messaging.subscribeToTopic(topic);

  //   // 3. On iOS, this helps to take the user permissions
  // }

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
        _stack.add(const AppointmentsScreen());
        _stack.add(const WalletScreen(showAppBar: false));
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
                      'assets/images/logo.png', height: 30,
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
                  "assets/icons/profile.svg",
                  color: Colors.white,
                ),
              ),
              title: Image.asset(
                'assets/images/logo.png', height: 30,
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
                        "assets/icons/menu5.svg",
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
      bottomNavigationBar: CardContainer(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 50,
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
                // ScaffoldMessenger.of(context).showSnackBar(
                //   snackBarDefault(
                //     'Button Notifications',
                //     fontSize: 20,
                //     color: Colors.green,
                //   ),
                // );

                setState(() => currentIndex = 0);
              },
              isActive: currentIndex == 0,
            ),
            BottomNavItem(
              title: 'Appointments',
              svgScr: 'assets/icons/clipboard5.svg',
              press: () {
                setState(() => currentIndex = 1);
              },
              isActive: currentIndex == 1,
            ),
            BottomNavItem(
              title: 'Earnings',
              svgScr: 'assets/icons/wallet2.svg',
              press: () {
                setState(() => currentIndex = 2);
              },
              isActive: currentIndex == 2,
            ),
            // BottomNavItem(
            //   title: 'Documents',
            //   svgScr: 'assets/icons/nurse.svg',
            //   press: () {
            //     setState(() => currentIndex = 3);
            //   },
            //   isActive: currentIndex == 3,
            // ),
          ],
        ),
      ),
    );
  }
}
