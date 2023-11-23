import 'package:nars/api/appointment_api.dart';
import 'package:nars/api/auth_service.dart';
import 'package:nars/api/notification_api.dart';
import 'package:nars/api/payment_api.dart';
import 'package:nars/api/practitioner_api.dart';
import 'package:nars/api/system_profile_api.dart';
import 'package:nars/api/user_api.dart';
import 'package:nars/api/wallet_api.dart';
import 'package:nars/components/appointment_card.dart';
import 'package:nars/components/appointment_counts.dart';
import 'package:nars/components/button_default.dart';
import 'package:nars/components/dropdown_form_field_int.dart';
import 'package:nars/components/dropdown_form_field_string.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/components/subtitle.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/status.dart';
import 'package:nars/enumerables/usertype.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/appointment/appointment_count.dart';
import 'package:nars/models/appointment/get_appointment_by_practitioner_id_param.dart';
import 'package:nars/models/appointment/get_appointments_param.dart';
import 'package:nars/models/appointment/get_practitioner_appointments_count_param.dart';
import 'package:nars/models/common/date_filter.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/models/payment/dragonpay_body_cc.dart';
import 'package:nars/models/payment/pay_response.dart';
import 'package:nars/models/payment/pay_subscription_param.dart';
import 'package:nars/models/payment_channel/payment_channel.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:nars/screens/appointment/appointment_screen.dart';
import 'package:nars/screens/in_app_browser/in_app_browser_screen.dart';
import 'package:nars/screens/settings/settings_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({
    Key? key,
    required this.update,
  }) : super(key: key);

  final ValueChanged<int> update;

  @override
  _DoctorDashboardScreenState createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  String name = '';
  bool isPending = false;
  bool isExpiring = false;
  DateTime? expiration;
  int _subscriptionType = 0;
  Practitioner? practitioner;
  String _MOP = '';
  List<PaymentChannel>? paymentChannels;
  String? txnId;

  Future<void> _refresh() async {
    setState(() {});
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool isLoadOnce = true;
  Future<void> getName() async {
    EasyLoading.show(status: 'loading...');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id') == null ? "" : prefs.getString('id')!;
    var topic = prefs.getString('name') == null ? "" : prefs.getString('name')!;
    var userType =
        prefs.getString('userType') == null ? "" : prefs.getString('userType')!;
    print("TOPICz");
    print(topic);

    if (!kIsWeb) {
      await NotificationApi.init();
      FirebaseMessaging.onMessage.listen((event) async {
        NotificationApi.showNotification(
            body: event.notification!.body, title: event.notification!.title);

        setState(() {});
        print("onMessage");
      });

      if (topic != "") await messaging.subscribeToTopic(topic);
      await messaging.subscribeToTopic(userType);
    }
    if (isLoadOnce) {
      var a = await UserApi.getUserData();
      expiration = a.expiration;
    }
    practitioner = await PractitionerApi.getPractitioner(int.parse(id));
    setState(() {
      if (isLoadOnce) {
        isLoadOnce = false;
      }
      name = practitioner!.fullName!;
      debugPrint('expiration: ${expiration}');
      if (expiration != null) {
        debugPrint('day diff: ${daysBetween(DateTime.now(), expiration!)}');
        if (daysBetween(DateTime.now(), expiration!) <= 5) {
          isExpiring = true;
        }
      }
      // debugPrint(practitioner.status!.name);
      if (practitioner!.status == Status.WaitingForApproval) {
        isPending = true;
        // showDialog(
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Column(
        //       children: [
        //         Image.asset(
        //           'assets/images/doctors.png',
        //           height: 200,
        //         ),
        //         const SizedBox(height: defaultPadding),
        //         Text(
        //           'Waiting for approval',
        //           style: Theme.of(context).textTheme.headline6,
        //           textAlign: TextAlign.center,
        //         ),
        //       ],
        //     ),
        //     content: const Text(
        //         'Please upload the required documents and wait for your approval, thank you'),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();

        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => const SettingsScreen(),
        //             ),
        //           );
        //         },
        //         child: const Text('Okay'),
        //       ),
        //     ],
        //   ),
        // );
      }
    });
    EasyLoading.dismiss();
    print("TOKEN " + FirebaseMessaging.instance.getToken().toString());
  }

  @override
  void initState() {
    super.initState();
    getName();
    getPaymentChannels();
  }

  Future<void> getPaymentChannels() async {
    var result = await WalletApi.getPaymentChannels();
    paymentChannels = result;
  }

  Future<void> pay() async {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      EasyLoading.show(status: 'loading...');
      _formKey.currentState?.save();

      var systemProfile = await SystemProfileApi.getSystemProfile();
      var _payResponse = await PaymentApi.paySubscription(
        PaySubscriptionParam(
          userId: practitioner!.id!,
          subscriptionType: _subscriptionType,
          dragonPayBodyCc: DragonPayBodyCc(
            amount: (_subscriptionType == 0
                    ? systemProfile.practitionerSubscriptionFee * 12
                    : systemProfile.practitionerSubscriptionFee)
                .toString(),
            currency: 'PHP',
            description: '-',
            // email: _practitioner?.userAccount?.email ?? '',
            email: practitioner!.userAccount!.email,
            procId: _MOP,
            param1: 'string',
            param2: 'string',
            billingDetails: BillingDetails(
              firstName: name,
              middleName: name,
              lastName: name,
              address1: 'Raniag st',
              address2: 'Antonino',
              city: 'Alicia',
              province: 'Isabela',
              country: 'Philippines',
              zipCode: '3306',
              telNo: practitioner!.userAccount!.phoneNumber,
              email: 'hansmagz@gmail.com',
            ),
            ipAddress: 'string',
            userAgent: 'string',
          ),
        ),
      );

      if (_payResponse is PayResponse) {
        txnId = _payResponse.txnId;
        EasyLoading.dismiss();
        if (kIsWeb) {
          // _launchUrl(Uri.parse(_payResponse.url));
          launchUrl(Uri.parse(_payResponse.url));
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Continue',
                style: Theme.of(context).textTheme.headline6,
              ),
              content: const Text('Confirm payment?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InAppBrowserScreen(
                url: _payResponse.url,
                titleText: 'screens/doctor_dashboard.dart'
              ),
            ),
          );
        }

        EasyLoading.show(status: 'loading...');

        var _verifyPayment = await PaymentApi.verifyPayment(txnId!);

        if (_verifyPayment.paymentStatus == 'Success') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Column(
                children: [
                  Image.asset(
                    'assets/images/doctors.png',
                    height: 200,
                  ),
                  const SizedBox(height: defaultPadding),
                  Text(
                    'Paid successfully',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              content:
                  const Text("You've extended your subscription, thank you"),
              actions: [
                TextButton(
                  onPressed: () {
                    // Navigator.popUntil(
                    //   context,
                    //   ModalRoute.withName('/'),
                    // );
                    Navigator.of(context).pop();

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const MainPatientScreen(),
                    //   ),
                    // );
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarDefault(
              text: 'Payment failed',
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarDefault(),
        );
      }
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<AuthService>(context).currentUser!;
    var now = DateTime.now();
    var startOfDay = DateTime(now.year, now.month, now.day, 0, 0);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // padding: EdgeInsets.symmetric(
          //   vertical: defaultPadding,
          //   horizontal: Responsive.isDesktop(context)
          //       ? size.width * 0.30
          //       : defaultPadding,
          // ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isPending) ...[
                Container(
                  width: size.width,
                  padding: const EdgeInsets.all(defaultPadding),
                  color: Colors.orangeAccent.withOpacity(0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Waiting for approval\n\nPlease update your profile on settings and wait for your approval, thank you',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: defaultPadding),
              ],
              if (isExpiring) ...[
                Container(
                  width: size.width,
                  padding: const EdgeInsets.all(defaultPadding),
                  color: Colors.orangeAccent.withOpacity(0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expiring\n\nYour subscription will expire on ${DateFormat('MMMM d, yyyy').format(expiration!)} please settle your payment, thank you',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Column(
                                children: [
                                  Text(
                                    'Subscription Payment',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: defaultPadding / 2),
                                  Text(
                                    'Pay for a month or year?',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                              content: Form(
                                key: _formKey,
                                autovalidateMode: _submitted
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min, //Required
                                  children: [
                                    const SizedBox(height: defaultPadding),
                                    DropdownFormFieldInt(
                                      label: 'Select',
                                      border: const BorderSide(
                                        width: 2,
                                        color: kPrimaryColor,
                                      ),
                                      onChanged: (value) {},
                                      onSaved: (value) => setState(
                                          () => _subscriptionType = value!),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      values: getSubscriptions(),
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    DropdownFormFieldString(
                                      label: 'Mode of Payment',
                                      border: const BorderSide(
                                        width: 2,
                                        color: kPrimaryColor,
                                      ),
                                      onChanged: (value) {},
                                      onSaved: (value) =>
                                          setState(() => _MOP = value!),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // value: practitioner != null
                                      //     ? practitioner!.information!.gender.index
                                      //     : widget.patientProfile != null
                                      //         ? patientProfile!.information.gender.index
                                      //         : null,
                                      values: paymentChannels == null
                                          ? null
                                          : paymentChannels!.map((x) {
                                              return DropdownMenuItem(
                                                child: Text(x.name),
                                                value: x.procId,
                                              );
                                            }).toList(),
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigator.of(context).pop();

                                    pay();
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'Pay',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: defaultPadding),
              ],
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: defaultPadding,
                  horizontal: Responsive.isDesktop(context)
                      ? size.width * 0.30
                      : defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hello', style: TextStyle(fontSize: 20)),
                    Text(
                      (user.userType == UserType.Doctor ? 'Dr. ' : 'Nurse ') +
                          name,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 30,
                          ),
                    ),
                    const SizedBox(height: defaultPadding),
                    FutureBuilder(
                      future: AppointmentApi.getPractitionerAppointmentsCount(
                        GetPractitionerAppointmentsCountParam(
                          practitionerId: user.id,
                          dateFilterCommon: DateFilterCommon(
                            start: startOfDay,
                            end: startOfDay.add(const Duration(days: 90)),
                          ),
                        ),
                      ),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<AppointmentCount>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          var data = snapshot.data!;
                          var pending = data
                                  .firstWhereOrNull(
                                      (x) => x.appointmentStatus == 'Pending')
                                  ?.count ??
                              0;
                          var approved = data
                                  .firstWhereOrNull(
                                      (x) => x.appointmentStatus == 'Approved')
                                  ?.count ??
                              0;
                          var completed = data
                                  .firstWhereOrNull(
                                      (x) => x.appointmentStatus == 'Completed')
                                  ?.count ??
                              0;
                          return AppointmentCounts(
                            size: size,
                            pending: pending,
                            approved: approved,
                            completed: completed,
                          );
                        } else {
                          return AppointmentCounts(
                            size: size,
                            pending: 0,
                            approved: 0,
                            completed: 0,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: defaultPadding),
                    const SubtitleDefault(title: 'For Approvals'),
                    const SizedBox(height: defaultPadding),
                    FutureBuilder(
                      future: user.userType == UserType.Doctor
                          ? AppointmentApi.getPractitionerAppointments(
                              GetAppointmentByPractitionerIdParam(
                                practitionerId: user.id,
                                pageCommon: PageCommon(
                                  page: 1,
                                  pageSize: 0,
                                ),
                                appointmentStatuses: [
                                  0, //Pending
                                  1, //WaitingForApproval
                                  8, //ReschedByPractitioner
                                  9, //ReschedByPatient
                                ],
                                isDescending: false,
                              ),
                            )
                          : AppointmentApi.getAppointments(
                              GetAppointmentsParam(
                                pageCommon: PageCommon(
                                  page: 1,
                                  pageSize: 0,
                                ),
                                isForNurse: true,
                              ),
                            ),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Appointment>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          var data = snapshot.data!;
                          if (data.isNotEmpty) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: index == data.length - 1
                                          ? 0
                                          : defaultPadding),
                                  child: AppointmentCard(
                                    height: 165,
                                    appointment: data[index],
                                    showPatient: true,
                                    press: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AppointmentScreen(
                                            appointmentId: data[index].id,
                                          ),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Waiting for appointments',
                                style: TextStyle(fontSize: 20),
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
                  ],
                ),
              ),

              // Column(
              //   children: List.generate(
              //     _appointments.length,
              //     (index) => Padding(
              //       padding: EdgeInsets.only(
              //         bottom:
              //             index == _appointments.length - 1 ? 0 : defaultPadding,
              //       ),
              //       child: AppointmentCardDemo(
              //         appointment: _appointments[index],
              //         showStatus: false,
              //         showPatient: true,
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
              //   ).toList(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
