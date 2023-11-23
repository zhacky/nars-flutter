import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/firebase_options.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:nars/api/auth_service.dart';
import 'package:nars/screens/contact_us/contact_us_screen.dart';
import 'package:nars/screens/login/login_screen.dart';
import 'package:nars/screens/main/main_practitioner_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 1));
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.removeAfter(initialization);

  await TokenPreferences.init();
  // debugPaintSizeEnabled = true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        Provider<Flavor>.value(value: Flavor.Practitioner),
      ],
      child: const MyApp(),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    // ..displayDuration = const Duration(milliseconds: 2000)
    // ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    // ..indicatorSize = 45.0
    // ..radius = 10.0
    // ..progressColor = Colors.yellow
    ..textStyle =
        const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)
    ..backgroundColor = kPrimaryColor
    ..indicatorColor = Colors.white
    ..textColor = Colors.white;
  // ..maskColor = Colors.blue.withOpacity(0.5)
  // ..userInteractions = true
  // ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String topic = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getName();
  }

  // getName() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     topic = prefs.getString('name') == null ? "" : prefs.getString('name')!;
  //   });

  //   if (topic != "") messaging.subscribeToTopic(topic);
  //   print("TOPICz");
  //   print(topic);
  //   FirebaseMessaging.onMessage.listen((event) {
  //     setState(() {
  //       notificationMessage = "${event.notification!.title} from terminated";
  //     });
  //     print("terminated");
  //   });
  //   FirebaseMessaging.instance.getInitialMessage().then((event) {
  //     setState(() {
  //       notificationMessage = "${event?.notification!.title} from foreground";
  //     });
  //     print("foreground");
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     setState(() {
  //       notificationMessage = "${event.notification!.title} from background";
  //     });
  //     print("background");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      // initialRoute: '/',
      // routes: {
      //   '/': ((context) => const LoginScreen()),
      //   // '/': ((context) => const MainDoctorScreen()),
      // },
      debugShowCheckedModeBanner: false,
      title: 'Nars Practitioner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      // ThemeData(
      //   textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      // ),
      // home: const MainPage(),
      home: FutureBuilder(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.hasData
                ? const MainPractitionerScreen()
                // ? const SettingsScreen()
                : const LoginScreen();
          } else {
            return Container(
              color: Colors.white,
            );
          }
        },
      ),
      routes: {
        '/contactus': ((context) => const ContactUsScreen()),
      },
      builder: EasyLoading.init(),
    );
  }
}
