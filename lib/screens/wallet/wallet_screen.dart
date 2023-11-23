import 'dart:convert';

import 'package:nars/api/appointment_api.dart';
import 'package:nars/api/auth_service.dart';
import 'package:nars/api/notification_api.dart';
import 'package:nars/api/user_api.dart';
import 'package:nars/api/wallet_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/components/dropdown_form_field_string.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/appointment_status.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/appointment/get_appointment_by_practitioner_id_param.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/models/processors/processors.dart';
import 'package:nars/models/wallet/wallet.dart';
import 'package:nars/models/wallet/withdrawal_param.dart';
import 'package:nars/models/wallet/withdrawal_response.dart';
import 'package:nars/screens/appointment/appointment_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);

  final bool showAppBar;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  double _amount = 0;
  String? _acctNo;
  String? _processor;
  List<Processor>? processors;

  Future<void> _refresh() async {
    setState(() {});
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> load() async {
    var user = await UserApi.getUserData();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var topic = prefs.getString('name') == null ? "" : prefs.getString('name')!;

    print("TOPICzWallet");
    print(topic + "Wallet");
    if (!kIsWeb) {
      await NotificationApi.init();
      FirebaseMessaging.onMessage.listen((event) async {
        NotificationApi.showNotification(
            body: event.notification!.body, title: event.notification!.title);

        setState(() {});
        print("onMessage");
      });

      if (topic != "") await messaging.subscribeToTopic(topic + "Wallet");
    }
  }

  Future<void> withdraw() async {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      _formKey.currentState?.save();
      EasyLoading.show(status: 'loading...');

      var result = await WalletApi.withdraw(
        UserRequestForWithdrawalParam(
          amount: _amount,
          procId: _processor!,
          // procId: 'BOG',
          accountNumber: _acctNo!,
        ),
      );
      if (result.statusCode == 200) {
        UserRequestForWithdrawalResponse response =
            UserRequestForWithdrawalResponse.fromJson(jsonDecode(result.body));
        if (response.code == 0) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarDefault(
              text: 'Request for withdrawal sent successfully.',
              color: Colors.green,
              fontSize: 20,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarDefault(
              text: response.message,
              fontSize: 20,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarDefault(
            text: result.body,
            fontSize: 20,
          ),
        );
      }
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
    getProcessors();
  }

  Future<void> getProcessors() async {
    var result = await WalletApi.getProcessors();
    processors = result;
  }

  @override
  Widget build(BuildContext context) {
    final flavor = Provider.of<Flavor>(context);
    final user = Provider.of<AuthService>(context).currentUser!;
    final _appointments = appointments.reversed
        .where((x) => x.status == AppointmentStatusDemo.Completed)
        .toList();

    final _earnings = _appointments.map((x) => x.total).reduce((a, b) => a + b);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: widget.showAppBar ? AppBarDefault(title: 'Wallet') : null,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                CardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                          title: flavor == Flavor.Patient
                              ? 'Balance'
                              : 'Earnings'),
                      FutureBuilder(
                        future: WalletApi.getBalance(user.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<Wallet> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var data = snapshot.data!;
                            return Text(
                              '₱' +
                                  NumberFormat("#,###.00").format(data.amount),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.black87),
                            );
                          } else {
                            return Text(
                              '₱' + NumberFormat("#,###.00").format(0),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.black87),
                            );
                          }
                        },
                      ),
                      if (flavor == Flavor.Patient) ...[
                        const SizedBox(height: defaultPadding),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Top Up',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(defaultPadding),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(defaultBorderRadius),
                              ),
                            ),
                            backgroundColor: kPrimaryColor,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: defaultPadding),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Column(
                                  children: [
                                    Text(
                                      'Withdraw',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: defaultPadding / 2),
                                    Text(
                                      'Please input an amount to withdraw',
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
                                      DropdownFormFieldString(
                                        label: 'Processor',
                                        onChanged: (value) {},
                                        border: const BorderSide(
                                          width: 2,
                                          color: kPrimaryColor,
                                        ),
                                        onSaved: (value) =>
                                            setState(() => _processor = value!),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'This field is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                        values: processors == null
                                            ? null
                                            : processors!.map((x) {
                                                return DropdownMenuItem(
                                                  child: Text(x.description),
                                                  value: x.code,
                                                );
                                              }).toList(),
                                      ),
                                      const SizedBox(height: defaultPadding),
                                      InputFormField(
                                        label: 'Account No.',
                                        onSaved: (value) {
                                          _acctNo = value;
                                        },
                                        border: const BorderSide(width: 2),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'This field is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      const SizedBox(height: defaultPadding),
                                      InputFormField(
                                        label: 'Amount',
                                        onSaved: (value) {
                                          _amount = double.parse(value!);
                                        },
                                        border: const BorderSide(width: 2),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'This field is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
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

                                      withdraw();
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text(
                            'Withdraw',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(defaultPadding),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(defaultBorderRadius),
                              ),
                            ),
                            backgroundColor: kPrimaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: defaultPadding),
                CardContainer(
                  child: Column(
                    children: [
                      SectionTitle(
                        title: flavor == Flavor.Patient
                            ? 'Wallet Transactions'
                            : 'Earning History',
                      ),
                      const SizedBox(height: defaultPadding),
                      FutureBuilder(
                        future: AppointmentApi.getPractitionerAppointments(
                          GetAppointmentByPractitionerIdParam(
                            practitionerId: user.id,
                            pageCommon: PageCommon(
                              page: 1,
                              pageSize: 0,
                            ),
                            appointmentStatuses: [
                              4, //Completed
                            ],
                            isDescending: true,
                          ),
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Appointment>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var data = snapshot.data!;
                            return ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(defaultBorderRadius),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Appointment appointment = data[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: index == data.length - 1
                                            ? 0
                                            : defaultPadding),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: defaultPadding * .5,
                                      ),
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                appointment.patientName!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: defaultPadding * .5),
                                              Text(
                                                DateFormat('MMM d, yyyy')
                                                    .format(
                                                        appointment.schedule),
                                              )
                                            ],
                                          ),
                                          Text(
                                            '₱' +
                                                NumberFormat("#,###.00")
                                                    .format(appointment.total),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AppointmentScreen(
                                              appointmentId: appointment.id,
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
                // Expanded(
                //   child: Stack(
                //     children: [
                //       CardContainer(
                //         borderRadius: const BorderRadius.only(
                //           topLeft: Radius.circular(defaultBorderRadius),
                //           topRight: Radius.circular(defaultBorderRadius),
                //         ),
                //         child: SectionTitle(
                //           title: flavor == Flavor.Patient
                //               ? 'Wallet Transactions'
                //               : 'Earning History',
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(top: 50),
                //         child: CardContainer(
                //           padding: const EdgeInsets.fromLTRB(
                //               defaultPadding, 0, defaultPadding, defaultPadding),
                //           borderRadius: const BorderRadius.only(
                //             bottomLeft: Radius.circular(defaultBorderRadius),
                //             bottomRight: Radius.circular(defaultBorderRadius),
                //           ),
                //           child: SingleChildScrollView(
                //             child:Column(
                //               children: List.generate(
                //                 _appointments.length,
                //                 (index) => Column(
                //                   children: [
                //                     ListTile(
                //                       contentPadding: const EdgeInsets.symmetric(
                //                         horizontal: 0,
                //                         vertical: defaultPadding * .5,
                //                       ),
                //                       title: Row(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         children: [
                //                           Column(
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.start,
                //                             children: [
                //                               Text(
                //                                 _appointments[index]
                //                                     .profile
                //                                     .information
                //                                     .fullName,
                //                                 style: const TextStyle(
                //                                   fontWeight: FontWeight.w500,
                //                                   fontSize: 18,
                //                                 ),
                //                               ),
                //                               const SizedBox(
                //                                   height: defaultPadding * .5),
                //                               Text(DateFormat('MMM d, yyyy').format(
                //                                   _appointments[index].dateTime))
                //                             ],
                //                           ),
                //                           Text(
                //                             '₱' +
                //                                 NumberFormat("#,###.00").format(
                //                                     _appointments[index].total),
                //                             style: const TextStyle(
                //                               fontWeight: FontWeight.w500,
                //                               fontSize: 18,
                //                             ),
                //                           )
                //                         ],
                //                       ),
                //                       onTap: () {
                //                         // Navigator.push(
                //                         //   context,
                //                         //   MaterialPageRoute(
                //                         //     builder: (context) => AppointmentScreen(
                //                         //       appointment: _appointments[index],
                //                         //     ),
                //                         //   ),
                //                         // );
                //                       },
                //                     ),
                //                     if (index != _appointments.length - 1)
                //                       const Divider()
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
