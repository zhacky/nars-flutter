import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/firebase_options.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:nars/api/auth_service.dart';
import 'package:nars/screens/appointment/appointment_screen.dart';
import 'package:nars/screens/contact_us/contact_us_screen.dart';
import 'package:nars/screens/login/login_screen.dart';
import 'package:nars/screens/main/main_patient_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        Provider<Flavor>.value(value: Flavor.Patient),
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'Nars',
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
                ? const MainPatientScreen()
                // ? const AppointmentScreen(
                //     appointmentId: 71,
                //   )
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
