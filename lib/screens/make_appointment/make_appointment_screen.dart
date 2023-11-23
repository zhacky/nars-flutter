import 'dart:convert';

import 'package:nars/api/appointment_api.dart';
import 'package:nars/api/hospital_api.dart';
import 'package:nars/api/payment_api.dart';
import 'package:nars/api/patient_api.dart';
import 'package:nars/api/system_profile_api.dart';
import 'package:nars/api/wallet_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/button_default.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/components/checkbox_tile_default.dart';
import 'package:nars/components/dropdown_form_field_string.dart';
import 'package:nars/components/hospital_tile.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/network_picture_card.dart';
import 'package:nars/components/radio_default.dart';
import 'package:nars/components/service_card.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/components/text_button_default.dart';
import 'package:nars/components/time_button.dart';
import 'package:nars/components/title_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/enumerables/nurse_services.dart';
import 'package:nars/enumerables/patient_contraption.dart';
import 'package:nars/enumerables/patient_mobility.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/appointment/add_appointment_param.dart';
import 'package:nars/models/appointment/add_appointment_response.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/appointment/delete_doctor_appointment_param.dart';
import 'package:nars/models/appointment/get_appointment_by_practitioner_id_param.dart';
import 'package:nars/models/appointment/nurse_appointment_param.dart';
import 'package:nars/models/common/date_filter.dart';
import 'package:nars/models/demo/event_demo.dart';
import 'package:nars/models/demo/hospital_demo.dart';
import 'package:nars/models/hospital/hospital_schedule.dart';
import 'package:nars/models/nurse_added_fee/nurse_added_fee_item.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/models/patient/profile.dart';
import 'package:nars/models/payment/dragonpay_body_cc.dart';
import 'package:nars/models/payment/pay_param.dart';
import 'package:nars/models/payment/pay_response.dart';
import 'package:nars/models/payment_channel/payment_channel.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:nars/models/practitioner/practitioner_hospital.dart';
import 'package:nars/providers/nurse_added_fee_provider.dart';
import 'package:nars/providers/patient_profiles_provider.dart';
import 'package:nars/screens/account_information/account_information_screen.dart';
import 'package:nars/screens/hospital_schedule_form/hospital_schedule_form_screen.dart';
import 'package:nars/screens/in_app_browser/in_app_browser_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class MakeAppointmentScreen extends StatefulWidget {
  const MakeAppointmentScreen({
    Key? key,
    this.practitioner,
  }) : super(key: key);

  final Practitioner? practitioner;

  @override
  _MakeAppointmentScreenState createState() => _MakeAppointmentScreenState();
}

class _MakeAppointmentScreenState extends State<MakeAppointmentScreen> {
  ProfileManager manager = ProfileManager();
  late Stream<List<Appointment>> appointmentsStream;
  List<PaymentChannel>? paymentChannels;
  bool firstLoad = true;
  int _activeStepIndex = 0;
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  bool _submitted2 = false;
  bool _submitted3 = false;
  bool _submitted4 = false;
  bool isLoading = false;

  // late final ValueNotifier<List<Event>> _selectedEvents;
  // late List<Appointment> _appointments;
  List<DateTime>? _occupieds;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _time;
  DateTime? _dateTime;

  int _type = 0;
  int _covid = 0;
  DateTime? _covidDate;
  TextEditingController covidController = TextEditingController();
  String _reason = '';
  Profile? _profile;
  String? txnId;
  double doctorSystemFee = 0;
  double covidPercentageFee = 0;
  String _MOP = '';

  //Nurse
  double nurseCommissionPerc = 0;
  int _hours = 2;
  List<NurseAddedFeeItem> _nurseServices = [];
  List<int> _nurseServicesIds = [];
  NurseAddedFeeItem? _mobilityObj;
  int _mobility = 0;
  List<NurseAddedFeeItem> _patientContraptions = [];
  List<int> _patientContraptionsIds = [];
  String? _other;

  late Stream<List<PractitionerHospital>> hospitalsStream;

  Stream<List<PractitionerHospital>> getPractitionerHospitals(
      int practitionerId, String day) async* {
    yield await HospitalApi.getPractitionerHospitalsWithDay(
        practitionerId, day);
  }
  // List<PractitionerHospital>? practitionerHospitals;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    if (widget.practitioner != null) {
      appointmentsStream = getappointments(_selectedDay!);
      hospitalsStream = getPractitionerHospitals(
          widget.practitioner!.id!, DateFormat('EEEE').format(DateTime.now()));
    }

    getSystemFee();
    getPaymentChannels();
  }

  @override
  void dispose() {
    // _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> getSystemFee() async {
    var result = await SystemProfileApi.getSystemProfile();
    nurseCommissionPerc = result.commissionFromNursePercentage;
    doctorSystemFee = result.systemFee;
    covidPercentageFee = result.covidPercentageFee;
    // return result.commissionFromNursePercentage;
  }

  Future<void> getPaymentChannels() async {
    var result = await WalletApi.getPaymentChannels();
    paymentChannels = result;
  }

  Stream<List<Appointment>> getappointments(DateTime selectedDay) async* {
    var start = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    var data = await AppointmentApi.getPractitionerAppointments(
      GetAppointmentByPractitionerIdParam(
        practitionerId: widget.practitioner!.id!,
        pageCommon: PageCommon(
          page: 1,
          pageSize: 0,
        ),
        scheduleFilterCommon: DateFilterCommon(
          start: start,
        ),
        appointmentStatuses: [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
        ],
        isDescending: false,
      ),
    );
    debugPrint("DATA: ${appointmentsToJson(data)}");
    yield data;
  }

  void submit2() async {
    setState(() {
      _submitted2 = true;
    });
    final isValid = _formKey2.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      _formKey2.currentState?.save();
      // debugPrint('_other: $_other');
      setState(() {
        _activeStepIndex += 1;
      });
    }
  }

  void submit3() async {
    setState(() {
      _submitted3 = true;
    });
    final isValid = _formKey3.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      _formKey3.currentState?.save();
      setState(() {
        _activeStepIndex += 1;
      });
    }
  }

  // List<Event> _getEventsForDay(DateTime day) {
  //   return kEvents[day] ?? [];
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _time = null;
        _dateTime = null;
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        if (widget.practitioner != null) {
          appointmentsStream = getappointments(_selectedDay!);
          hospitalsStream = getPractitionerHospitals(
              widget.practitioner!.id!, DateFormat('EEEE').format(selectedDay));
        }
      });
      // _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final userId = Provider.of<AuthService>(context).currentUser!.id;
    var _practitioner = widget.practitioner;
    var _firstDay = DateTime.now();
    var _lastDay = DateTime(_firstDay.year, _firstDay.month + 3, _firstDay.day);
    // var curDateTime = DateTime.now();
    // var curDateTime = DateTime(2022, 3, 4, 11, 0);
    var _curDateTime = _focusedDay.month == DateTime.now().month &&
            _focusedDay.day == DateTime.now().day
        ? DateTime.now()
        : _focusedDay;
    var _openTime = const TimeOfDay(hour: 8, minute: 0);
    var _closeTime = const TimeOfDay(hour: 20, minute: 0);
    // var _openTime = widget.practitioner.openTime;
    // var _closeTime = widget.practitioner.closeTime;
    var _curOpenTime = timeToInt(_openTime) < dateToInt(_curDateTime)
        ? _curDateTime
        : DateTime(_curDateTime.year, _curDateTime.month, _curDateTime.day,
            _openTime.hour, _openTime.minute);

    var _endOfTheDay = DateTime(_curDateTime.year, _curDateTime.month,
        _curDateTime.day, _closeTime.hour, _closeTime.minute);
    var _roundedTime = _curOpenTime.roundMin;

    int _totalMinute = _endOfTheDay.difference(_roundedTime).inMinutes;
    int slots = _totalMinute > 0 ? (_totalMinute / 30).round() : 0;

    double computeNurse(double fee) {
      double base = _hours * fee;
      double result = 0;
      result += base;
      if (_covid == 1) {
        result += base * covidPercentageFee;
      }
      for (var i = 0; i < _nurseServices.length; i++) {
        result += base * _nurseServices[i].percentage;
      }
      if (_mobilityObj != null) {
        result += base * _mobilityObj!.percentage;
      }
      for (var i = 0; i < _patientContraptions.length; i++) {
        result += base * _patientContraptions[i].percentage;
      }
      return result;
    }

    double _consultationFee =
        _practitioner?.consultationFee ?? computeNurse(250);
    double _systemFee = _consultationFee * nurseCommissionPerc;
    double _total = _consultationFee + _systemFee;

    Future<void> deleteAppointment(int appointmentId) async {
      var result = await AppointmentApi.deleteDoctorAppointment(
        DeleteDoctorAppointmentParam(
          id: appointmentId,
        ),
      );
      if (result.statusCode != 200) {
        print(result.body);
      }
    }

    void _launchUrl(Uri url) async {
      if (!await launchUrl(url)) throw 'Could not launch $url';
    }

    Future<void> pay(int appointmentId, double totalFee) async {
      var _payResponse = await PaymentApi.pay(
        PayParam(
          appointmentId: appointmentId,
          dragonPayBodyCc: DragonPayBodyCc(
            amount: totalFee.toString(),
            currency: 'PHP',
            description: '-',
            // email: _practitioner?.userAccount?.email ?? '',
            email: 'hansmagz@gmail.com',
            procId: _MOP,
            param1: 'string',
            param2: 'string',
            billingDetails: BillingDetails(
              firstName: _profile!.information.firstName,
              middleName: _profile!.information.middleName ?? '',
              lastName: _profile!.information.lastName,
              address1: 'Raniag st',
              address2: 'Antonino',
              city: 'Alicia',
              province: 'Isabela',
              country: 'Philippines',
              zipCode: '3306',
              telNo: _practitioner?.userAccount?.phoneNumber ?? '',
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
            builder: (BuildContext context) => AlertDialog(
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
              builder: (BuildContext context) => InAppBrowserScreen(
                url: _payResponse.url,
                titleText: 'Payment',
              ),
            ),
          );
        }

        EasyLoading.show(status: 'loading...');

        var _verifyPayment = await PaymentApi.verifyPayment(txnId!);

        if (_verifyPayment.paymentStatus == 'Success') {
          print(_verifyPayment.runtimeType);
          print(_verifyPayment.paymentStatus.runtimeType);
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Column(
                children: [
                  Image.asset(
                    'assets/images/nurses.png',
                    height: 200,
                  ),
                  const SizedBox(height: defaultPadding),
                  Text(
                    "You've successfully booked an appointment",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              content: Text(
                  'Please wait for a Nurse, thank you.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/'),
                    );
                    // Navigator.of(context).pop();

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
          if (_verifyPayment.paymentStatus == 'Unkown') {
            deleteAppointment(appointmentId);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarDefault(
              text: 'Payment failed',
            ),
          );
        }
      } else {
        deleteAppointment(appointmentId);
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarDefault(),
        );
      }
      EasyLoading.dismiss();
    }

    void submit() async {
      setState(() {
        _submitted4 = true;
      });
      final isValid = _formKey4.currentState?.validate();
      FocusScope.of(context).unfocus();

      if (isValid!) {
        _formKey4.currentState?.save();
        EasyLoading.show(status: 'loading...');
        var result = await AppointmentApi.addAppointment(
          AddAppointmentParam(
            patientProfileId: _profile!.id,
            practitionerFee: _consultationFee,
            bookingType: _type,
            practitionerId: _practitioner?.id,
            minutes: _practitioner?.consultationMinute ?? (_hours * 60).round(),
            reason: _reason,
            schedule: _dateTime!,
            covid: _covid,
            dateOfTest: _covidDate,
            // nurseAppointmentDetail: _practitioner != null
            //     ? null
            //     : NurseAppointmentParam(
            //         nurseServices: _nurseServicesIds,
            //         patientMobility: _mobility,
            //         patientContraptionEnums: _patientContraptionsIds,
            //       ),
            nurseAddedFeeIds: _practitioner != null
                ? null
                : [..._nurseServicesIds, _mobility, ..._patientContraptionsIds],
          ),
        );
        if (result.statusCode == 200) {
          AddAppointmentResponse response =
              AddAppointmentResponse.fromJson(jsonDecode(result.body));
          // send payment
          if (_MOP != 'PIP') {
            pay(response.appointmentId, response.totalFee);
          } else {
            EasyLoading.dismiss();

            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Column(
                  children: [
                    Image.asset(
                      'assets/images/nurses.png',
                      height: 200,
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      "You've successfully booked an appointment",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                content: Text(
                  "Please wait for a Nurse, thank you."
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('/')
                      );
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ),
            );
          }
        } else {
          debugPrint('AddApointmentError: ${result}');
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarDefault(
              text: result.body,
              fontSize: 20,
            ),
          );
          EasyLoading.dismiss();
        }
      }
    }

    Widget _buildSelectType() {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleDefault(title: 'Select Type of Appointment'),
            const SizedBox(height: defaultPadding),
            Wrap(
              spacing: defaultPadding,
              runSpacing: defaultPadding,
              children: <Widget>[
                ServiceCard(
                  title: 'Online',
                  imgScr: 'assets/images/online.png',
                  color: _type == 0
                      ? kPrimaryColor.withOpacity(0.3)
                      : Colors.white,
                  onTap: () {
                    setState(() {
                      _type = 0;
                    });
                  },
                ),
                ServiceCard(
                  title: 'At Clinic',
                  imgScr: 'assets/images/clinic.png',
                  color: _type == 1
                      ? kPrimaryColor.withOpacity(0.3)
                      : Colors.white,
                  onTap: () {
                    setState(() {
                      _type = 1;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildDateTime() {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleDefault(
              title: 'When would you like a nurse to come visit you?',
            ),
            TableCalendar<Event>(
              availableGestures: AvailableGestures.horizontalSwipe,
              firstDay: _firstDay,
              lastDay: _lastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              // eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                selectedDecoration: BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: _onDaySelected,
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  return Text(
                    DateFormat('MMMM yyyy').format(day),
                    style: Theme.of(context).textTheme.headline6,
                  );
                },
                // dowBuilder: (context, day) {
                //   final text = DateFormat.E().format(day);
                //   return Center(
                //     child: Text(
                //       text,
                //       style: TextStyle(color: Colors.red),
                //     ),
                //   );
                // },
              ),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: defaultPadding),
            // Expanded(
            //   child: ValueListenableBuilder<List<Event>>(
            //     valueListenable: _selectedEvents,
            //     builder: (context, value, _) {
            //       return ListView.builder(
            //         itemCount: value.length,
            //         itemBuilder: (context, index) {
            //           return Container(
            //             margin: const EdgeInsets.symmetric(
            //               horizontal: 12.0,
            //               vertical: 4.0,
            //             ),
            //             decoration: BoxDecoration(
            //               border: Border.all(),
            //               borderRadius: BorderRadius.circular(12.0),
            //             ),
            //             child: ListTile(
            //               onTap: () => print('${value[index]}'),
            //               title: Text('${value[index]}'),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),

            // const TitleDefault(title: 'Time'),
            // const SizedBox(height: defaultPadding),
            if (widget.practitioner != null) ...[
              StreamBuilder(
                stream: appointmentsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Appointment>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Appointment> appointments = snapshot.data!;
                    _occupieds = appointments.map((e) => e.schedule).toList();
                    return const SizedBox.shrink();
                    // return Wrap(
                    //   direction: Axis.horizontal,
                    //   spacing: defaultPadding,
                    //   runSpacing: defaultPadding,
                    //   children: List.generate(
                    //     slots,
                    //     (index) {
                    //       var time = _roundedTime.plusThirty(index);
                    //       var occupied = _occupieds!.contains(time);

                    //       return TimeButton(
                    //         label: DateFormat('h:mm a').format(time),
                    //         index: index,
                    //         selectedIndex: _time,
                    //         occupied: occupied,
                    //         press: () {
                    //           if (!occupied) {
                    //             setState(() {
                    //               _time = index;
                    //               _dateTime = time;
                    //             });
                    //           } else {
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               snackBarDefault(
                    //                 text: 'Sorry, this time slot is occupied',
                    //                 fontSize: 16,
                    //               ),
                    //             );
                    //           }
                    //         },
                    //       );
                    //     },
                    //   ),
                    // );
                  } else {
                    return const SizedBox.shrink();
                    // return const Center(
                    //   child: SizedBox(
                    //     height: 50,
                    //     width: 50,
                    //     child: Center(
                    //       child: CircularProgressIndicator(),
                    //     ),
                    //   ),
                    // );
                  }
                },
              ),
            ] else ...[
              Wrap(
                direction: Axis.horizontal,
                spacing: defaultPadding,
                runSpacing: defaultPadding,
                children: List.generate(
                  slots,
                  (index) {
                    var time = _roundedTime.plusThirty(index);

                    return TimeButton(
                      label: DateFormat('h:mm a').format(time),
                      time: time,
                      selectedTime: _dateTime,
                      index: index,
                      selectedIndex: _time,
                      press: () {
                        setState(() {
                          _time = index;
                          _dateTime = time;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
            if (widget.practitioner != null) ...[
              const TitleDefault(title: 'Time'),
              const SizedBox(height: defaultPadding),
              StreamBuilder(
                stream: hospitalsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PractitionerHospital>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<PractitionerHospital> practitionerHospital =
                        snapshot.data!;
                    debugPrint(
                        "practitionerHospital: ${getPractitionerHospitalsToJson(practitionerHospital)}");
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: practitionerHospital.length,
                      itemBuilder: (BuildContext context, int index) {
                        PractitionerHospital _data =
                            practitionerHospital[index];
                        List<HospitalSchedule> hospitalSchedule =
                            _data.hospitalSchedule;

                        var hSTS =
                            hospitalSchedule.first.hospitalScheduleTimeSpans;

                        return Column(
                          children: List.generate(
                            hSTS.length,
                            (index) {
                              var _openTime = hSTS[index].start!;
                              var _closeTime = hSTS[index].end!;
                              var _curOpenTime =
                                  timeToInt(_openTime) < dateToInt(_curDateTime)
                                      ? _curDateTime
                                      : DateTime(
                                          _curDateTime.year,
                                          _curDateTime.month,
                                          _curDateTime.day,
                                          _openTime.hour,
                                          _openTime.minute);

                              var _endOfTheDay = DateTime(
                                  _curDateTime.year,
                                  _curDateTime.month,
                                  _curDateTime.day,
                                  _closeTime.hour,
                                  _closeTime.minute);
                              var _roundedTime = _curOpenTime.roundMin;

                              int _totalMinute = _endOfTheDay
                                  .difference(_roundedTime)
                                  .inMinutes;
                              int slots = _totalMinute > 0
                                  ? (_totalMinute / 30).round()
                                  : 0;

                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: defaultPadding),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing: defaultPadding,
                                  runSpacing: defaultPadding,
                                  children: List.generate(
                                    slots,
                                    (index) {
                                      var time = _roundedTime.plusThirty(index);
                                      var occupied = _occupieds!.contains(time);

                                      return TimeButton(
                                        label:
                                            DateFormat('h:mm a').format(time),
                                        time: time,
                                        selectedTime: _dateTime,
                                        index: index,
                                        selectedIndex: _time,
                                        occupied: occupied,
                                        press: () {
                                          if (!occupied) {
                                            setState(() {
                                              _time = index;
                                              _dateTime = time;
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              snackBarDefault(
                                                text:
                                                    'Sorry, this time slot is occupied',
                                                fontSize: 16,
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );

                        // return Padding(
                        //   padding: const EdgeInsets.only(bottom: 4),
                        //   child: HospitalTile(
                        //     hospital: _data,
                        //     press: () {},
                        //   ),
                        // );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
            const SizedBox(height: defaultPadding),
            if (slots == 0)
              Text(
                'Today is already closed.',
                style: Theme.of(context).textTheme.titleMedium,
              )
          ],
        ),
      );
    }

    Widget _buildService() {
      return Column(
        children: [
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleDefault(
                  title: 'How many hours would you require for home care?',
                ),
                RadioDefault(
                  text: '<12 HOURS',
                  value: 12,
                  groupValue: _hours,
                  onChanged: (value) {
                    setState(() {
                      _hours = value!;
                    });
                  },
                ),
                RadioDefault(
                  text: '24 HOURS',
                  value: 24,
                  groupValue: _hours,
                  onChanged: (value) {
                    setState(() {
                      _hours = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding),
          ChangeNotifierProvider(
            create: (context) => NurseAddedFeeProvider(),
            child: Builder(
              builder: (BuildContext context) {
                final model = Provider.of<NurseAddedFeeProvider>(context);
                if (model.homeState == HomeState.Loading) {
                  return const Text('Loading..');
                }
                if (model.homeState == HomeState.Error) {
                  return Center(
                    child: Text(
                        'Something went wrong, please try again.\n${model.message}'),
                  );
                }
                // List<Profile> profiles = snapshot.data!;
                final nurseAddedFees = model.nurseAddedFees;
                final nurseServices = nurseAddedFees
                    .firstWhere((x) => x.nurseDetail == 'NurseServices');
                final patientMobilities = nurseAddedFees
                    .firstWhere((x) => x.nurseDetail == 'PatientMobility');
                final patientContraptions = nurseAddedFees
                    .firstWhere((x) => x.nurseDetail == 'PatientContraption');
                // if (firstLoad) {
                //   _profile = model.profiles.first;
                //   firstLoad = false;
                // }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleDefault(
                            title:
                                'Select the Services to be given to the patient',
                          ),
                          ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: nurseServices.item.length,
                            itemBuilder: (BuildContext context, int index) {
                              final nurseService = nurseServices.item[index];
                              return CheckboxTileDefault(
                                text: nurseService.name,
                                value:
                                    _nurseServicesIds.contains(nurseService.id),
                                onChanged: (value) {
                                  var i = nurseService.id;
                                  setState(() {
                                    if (_nurseServicesIds.contains(i)) {
                                      _nurseServicesIds.remove(i);
                                      _nurseServices
                                          .removeWhere((x) => x.id == i);
                                    } else {
                                      _nurseServicesIds.add(i);
                                      _nurseServices.add(nurseService);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleDefault(
                            title: 'Please choose patient mobility',
                          ),
                          ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: patientMobilities.item.length,
                            itemBuilder: (BuildContext context, int index) {
                              final patientMobility =
                                  patientMobilities.item[index];
                              return RadioDefault(
                                text: patientMobility.name,
                                value: patientMobility.id,
                                groupValue: _mobility,
                                onChanged: (value) {
                                  setState(() {
                                    _mobility = value!;
                                    _mobilityObj = patientMobility;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleDefault(
                            title: 'Please choose patient current contraptions',
                          ),
                          ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: patientContraptions.item.length,
                            itemBuilder: (BuildContext context, int index) {
                              final patientContraption =
                                  patientContraptions.item[index];
                              return CheckboxTileDefault(
                                text: patientContraption.name,
                                value: _patientContraptionsIds
                                    .contains(patientContraption.id),
                                onChanged: (value) {
                                  var i = patientContraption.id;
                                  setState(() {
                                    if (_patientContraptionsIds.contains(i)) {
                                      _patientContraptionsIds.remove(i);
                                      _patientContraptions
                                          .removeWhere((x) => x.id == i);
                                    } else {
                                      _patientContraptionsIds.add(i);
                                      _patientContraptions
                                          .add(patientContraption);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // FutureBuilder(
          //   future: NurseAddedFeeApi.getNurseAddedFees(),
          //   builder: (BuildContext context,
          //       AsyncSnapshot<List<NurseAddedFee>> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       var data = snapshot.data!;
          //       var nurseServices =
          //           data.firstWhere((x) => x.nurseDetail == 'NurseServices');
          //       return ListView.builder(
          //         physics: const ClampingScrollPhysics(),
          //         shrinkWrap: true,
          //         itemCount: nurseServices.item.length,
          //         itemBuilder: (BuildContext context, int index) {
          //           var nurseService = nurseServices.item[index];
          //           return CheckboxTileDefault(
          //             text: nurseService.name,
          //             value: _nurseServices
          //                 .contains(NurseServices.values[index].index),
          //             onChanged: (value) {
          //               var i = NurseServices.values[index].index;
          //               setState(() {
          //                 if (_nurseServices.contains(i)) {
          //                   _nurseServices.remove(i);
          //                 } else {
          //                   _nurseServices.add(i);
          //                 }
          //               });
          //             },
          //           );
          //         },
          //       );
          //     } else {
          //       return CardContainer(
          //         width: MediaQuery.of(context).size.width * 0.8,
          //         child: const Text('Loading..'),
          //       );
          //     }
          //   },
          // ),
          // CardContainer(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const TitleDefault(
          //         title: 'Select the Services to be given to the patient',
          //       ),
          //       Column(
          //         children: List.generate(
          //           NurseServices.values.length,
          //           (index) => CheckboxTileDefault(
          //             text: getNurseServicesName(NurseServices.values[index]),
          //             value: _nurseServices
          //                 .contains(NurseServices.values[index].index),
          //             onChanged: (value) {
          //               var i = NurseServices.values[index].index;
          //               setState(() {
          //                 if (_nurseServices.contains(i)) {
          //                   _nurseServices.remove(i);
          //                 } else {
          //                   _nurseServices.add(i);
          //                 }
          //               });
          //             },
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // CardContainer(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const TitleDefault(
          //         title: 'Please choose patient mobility',
          //       ),
          //       Column(
          //         children: List.generate(
          //           PatientMobility.values.length,
          //           (index) => RadioDefault(
          //             text: getPatientMobilitiesName(
          //                 PatientMobility.values[index]),
          //             value: PatientMobility.values[index].index,
          //             groupValue: _mobility,
          //             onChanged: (value) {
          //               setState(() {
          //                 _mobility = value!;
          //               });
          //             },
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: defaultPadding),
          // CardContainer(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const TitleDefault(
          //         title: 'Please choose patient current contraptions',
          //       ),
          //       Column(
          //         children: List.generate(
          //           PatientContraption.values.length,
          //           (index) => CheckboxTileDefault(
          //             text: PatientContraption.values[index].name,
          //             value: _patientContraptions
          //                 .contains(PatientContraption.values[index].index),
          //             onChanged: (value) {
          //               var i = PatientContraption.values[index].index;
          //               setState(() {
          //                 if (_patientContraptions.contains(i)) {
          //                   _patientContraptions.remove(i);
          //                 } else {
          //                   _patientContraptions.add(i);
          //                 }
          //               });
          //             },
          //           ),
          //         ),
          //       ),
          //       if (_patientContraptions.contains(4)) ...[
          //         const SizedBox(height: defaultPadding / 2),
          //         InputFormField(
          //           label: 'Other Contraption',
          //           initialValue: _other,
          //           border: const BorderSide(),
          //           onChanged: (value) => setState(() => _other = value!),
          //           validator: (value) {
          //             if (value!.isEmpty) {
          //               return 'This field is required';
          //             } else {
          //               return null;
          //             }
          //           },
          //         ),
          //       ],
          //     ],
          //   ),
          // ),
        ],
      );
    }

    Widget _buildCovidDateField() {
      return GestureDetector(
        onTap: () {
          showDatePicker(
            context: context,
            // initialDatePickerMode: DatePickerMode.year,
            initialDate: _covidDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ).then((date) => {
                setState(() {
                  _covidDate = date;
                  covidController.text =
                      DateFormat('MM/dd/yyyy').format(date ?? DateTime.now());
                }),
              });
        },
        child: AbsorbPointer(
          child: InputFormField(
            label: 'Date of Test',
            border: const BorderSide(),
            textEditingController: covidController,
            onSaved: (value) {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
        ),
      );
    }

    Widget _buildCovid() {
      return CardContainer(
        child: Form(
          key: _formKey2,
          autovalidateMode: _submitted2
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              const TitleDefault(
                title: 'Is the patient positive of COVID-19?',
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: _covid,
                    onChanged: (value) {
                      setState(() {
                        _covid = 1;
                      });
                    },
                  ),
                  Text(
                    'Yes',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: _covid,
                    onChanged: (value) {
                      setState(() {
                        _covid = 0;
                      });
                    },
                  ),
                  Text(
                    'No',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: _covid,
                    onChanged: (value) {
                      setState(() {
                        _covidDate = null;
                        covidController.text = '';
                        _covid = 2;
                      });
                    },
                  ),
                  Text(
                    'Not sure',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              if (_covid != 2) _buildCovidDateField(),
            ],
          ),
        ),
      );
    }

    Widget _buildDescription() {
      return CardContainer(
        child: Form(
          key: _formKey3,
          autovalidateMode: _submitted3
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.practitioner != null
                    ? 'Reason for Consultation'
                    : 'Reason for Home Service',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: defaultPadding),
              InputFormField(
                label: '',
                hintText:
                    'Please let us know your symptoms, chief complaint, fever/bp',
                border: const BorderSide(),
                textInputType: TextInputType.multiline,
                minLines: 2,
                maxLines: 10,
                onSaved: (value) => setState(() => _reason = value!),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: defaultPadding),
              const TitleDefault(title: 'Select or Add Patient Profile'),
              const SizedBox(height: defaultPadding),
              SizedBox(
                height: 168,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  child: ChangeNotifierProvider(
                    create: (context) => PatientProfilesProvider(),
                    child: Builder(
                      builder: (BuildContext context) {
                        final model =
                            Provider.of<PatientProfilesProvider>(context);
                        if (model.homeState == HomeState.Loading) {
                          return NetworkPictureCard(
                            assetImage: true,
                            height: 120,
                            width: 120,
                            color: Colors.white,
                            vertical: defaultPadding / 4,
                            boxShape: BoxShape.circle,
                            imageScr: 'assets/images/add_profile2.png',
                            title: 'Add New Profile',
                            press: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const AccountInformationScreen(),
                                ),
                              );

                              setState(() {});
                            },
                          );
                        }
                        if (model.homeState == HomeState.Error) {
                          return Center(
                            child: Text(
                                'Something went wrong, please try again.\n${model.message}'),
                          );
                        }
                        // List<Profile> profiles = snapshot.data!;
                        final profiles = model.profiles;
                        if (firstLoad) {
                          _profile = model.profiles.first;
                          firstLoad = false;
                        }

                        return ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: profiles.length,
                            itemBuilder: (BuildContext context, int index) {
                              // final profile = profiles[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                    right: index == profiles.length - 1
                                        ? 0
                                        : defaultPadding),
                                child: NetworkPictureCard(
                                  height: 120,
                                  width: 120,
                                  color: _profile!.id == profiles[index].id
                                      ? kPrimaryColor.withOpacity(0.3)
                                      : Colors.white,
                                  vertical: defaultPadding / 4,
                                  boxShape: BoxShape.circle,
                                  imageScr: profiles[index]
                                      .information
                                      .profilePicture!,
                                  title: profiles[index].information.fullName,
                                  press: () async {
                                    setState(() {
                                      _profile = profiles[index];
                                      // print(_profile);
                                    });
                                    // await Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         const AccountInformationScreen(),
                                    //   ),
                                    // );

                                    // setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // StreamBuilder(
                  //   stream: manager.profileListView,
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<List<Profile>> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.done ||
                  //         snapshot.connectionState == ConnectionState.active) {
                  //       List<Profile> profiles = snapshot.data!;
                  //       return ListView.builder(
                  //         physics: const ClampingScrollPhysics(),
                  //         scrollDirection: Axis.horizontal,
                  //         shrinkWrap: true,
                  //         itemCount: profiles.length + 1,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           // Profile _data = profiles[index];
                  //           return NetworkPictureCard(
                  //             assetImage: index >= profiles.length,
                  //             height: 120,
                  //             width: 120,
                  //             color: _profile == index
                  //                 ? kPrimaryColor.withOpacity(0.3)
                  //                 : Colors.white,
                  //             vertical: defaultPadding / 4,
                  //             boxShape: BoxShape.circle,
                  //             imageScr: index < profiles.length
                  //                 ? profiles[index].information.profilePicture!
                  //                 : 'assets/images/add_profile2.png',
                  //             title: index < profiles.length
                  //                 ? profiles[index].information.fullName
                  //                 : 'Add New Profile',
                  //             press: () async {
                  //               if (index < profiles.length) {
                  //                 setState(() {
                  //                   _profile = index;
                  //                 });
                  //               } else {
                  //                 await Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                     builder: (context) =>
                  //                         const AccountInformationScreen(),
                  //                   ),
                  //                 );

                  //                 setState(() {});
                  //               }
                  //             },
                  //           );
                  //         },
                  //       );
                  //     } else {
                  //       return NetworkPictureCard(
                  //         assetImage: true,
                  //         height: 120,
                  //         width: 120,
                  //         color: Colors.white,
                  //         vertical: defaultPadding / 4,
                  //         boxShape: BoxShape.circle,
                  //         imageScr: 'assets/images/add_profile2.png',
                  //         title: 'Add New Profile',
                  //         press: () async {
                  //           await Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const AccountInformationScreen(),
                  //             ),
                  //           );

                  //           setState(() {});
                  //         },
                  //       );
                  //     }
                  //   },
                  // ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox.shrink(),
                  ),
                  Expanded(
                    flex: 1,
                    child: ButtonDefault(
                      width: (size.width / 2) - (defaultPadding * 2),
                      title: 'Add New Profile',
                      press: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const AccountInformationScreen(),
                          ),
                        );

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildSummary() {
      return CardContainer(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: Theme.of(context).textTheme.headline6,
            ),
            if (_practitioner != null) ...[
              const SizedBox(height: defaultPadding),
              Text(
                'Practitioner Name',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                _practitioner.fullName!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
            const SizedBox(height: defaultPadding),
            Text(
              'Booking Type',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              _practitioner == null
                  ? 'Home Service'
                  : _type == 0
                      ? 'Online'
                      : 'Physical',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: defaultPadding),
            Text(
              'Schedule',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              _dateTime != null
                  ? DateFormat('MMMM d, yyyy h:mm a').format(_dateTime!)
                  : '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (_practitioner == null) ...[
              const SizedBox(height: defaultPadding),
              Text(
                'Hour/s of service',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                _hours.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: defaultPadding),
              Text(
                'Services',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Wrap(
                children: List.generate(
                  _nurseServices.length,
                  (index) => Text(
                    _nurseServices[index].name +
                        (index == _nurseServices.length - 1 ? '' : ', '),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Text(
                'Mobility',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                _mobilityObj?.name ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // Wrap(
              //   children: List.generate(
              //     _nurseServicesIds.length,
              //     (index) => Text(
              //       getNurseService(nurseServicesValues
              //               .map[_nurseServicesIds[index]]!.name) +
              //           (index == _nurseServicesIds.length - 1 ? '' : ', '),
              //       style: Theme.of(context).textTheme.titleMedium,
              //     ),
              //   ),
              // ),
              const SizedBox(height: defaultPadding),
              Text(
                'Patient Contraptions',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Wrap(
                children: List.generate(
                  _patientContraptions.length,
                  (index) => Text(
                    _patientContraptions[index].name +
                        (index == _patientContraptions.length - 1 ? '' : ', '),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              if (_other != null) ...[
                const SizedBox(height: defaultPadding),
                Text(
                  'Other contraption',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  _other ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ],
            const SizedBox(height: defaultPadding),
            Text(
              'COVID Patient',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            //TODO: get from enum
            Text(
              _covid == 0
                  ? 'No'
                  : _covid == 1
                      ? 'Yes'
                      : 'Not Sure',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (_covidDate != null) ...[
              const SizedBox(height: defaultPadding),
              Text(
                'Date of COVID test',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                _covidDate != null
                    ? DateFormat('MMMM d, yyyy').format(_covidDate!)
                    : '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],

            const SizedBox(height: defaultPadding),
            Text(
              'Reason for Consultation',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              _reason,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: defaultPadding),
            Text(
              'Patient Profile',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              _profile?.information.fullName ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    Widget _buildFee() {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Fee',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Consultation Fee:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '₱ ${NumberFormat("#,###.00").format(_consultationFee)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'System Fee:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '₱ ${NumberFormat("#,###.00").format(_systemFee)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '₱ ${NumberFormat("#,###.00").format(_total)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            RichText(
              text: TextSpan(
                text: 'By pressing CONFIRM, you accept and agree the ',
                style: const TextStyle(
                  color: Colors.black54,
                ),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                InAppBrowserScreen(
                                  url: 'http://nars.today/terms-and-conditions/',
                                  titleText: 'Terms and Conditions',
                                ),
                          ),
                        );
                      },
                      child: const Text(
                        'Terms and Conditions',
                        style: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                InAppBrowserScreen(
                                  url: 'http://nars.today/privacy-policy/',
                                  titleText: 'Privacy Policy',
                                ),
                          ),
                        );
                      },
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    List<Step> stepList() => [
          Step(
            state:
                _activeStepIndex <= 0 ? StepState.indexed : StepState.complete,
            isActive: _activeStepIndex >= 0,
            title: Text(_activeStepIndex == 0 ? 'Schedule' : ''),
            content: Column(
              children: [
                if (widget.practitioner != null) ...[
                  _buildSelectType(),
                  const SizedBox(height: defaultPadding),
                  const SizedBox(height: defaultPadding),
                ],
                _buildDateTime(),
              ],
            ),
          ),
          Step(
            state:
                _activeStepIndex <= 1 ? StepState.indexed : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: Text(_activeStepIndex == 1 ? 'Services' : ''),
            content: Column(
              children: [
                if (widget.practitioner == null) ...[
                  _buildService(),
                  const SizedBox(height: defaultPadding),
                ],
                _buildCovid(),
              ],
            ),
          ),
          Step(
            state: StepState.indexed,
            isActive: _activeStepIndex >= 2,
            title: Text(_activeStepIndex == 2 ? 'Profile' : ''),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDescription(),
              ],
            ),
          ),
          Step(
            state: StepState.indexed,
            isActive: _activeStepIndex >= 3,
            title: Text(_activeStepIndex == 3 ? 'Payment' : ''),
            content: Column(
              children: [
                _buildSummary(),
                const SizedBox(height: defaultPadding),
                _buildFee(),
                const SizedBox(height: defaultPadding),
                Form(
                  key: _formKey4,
                  autovalidateMode: _submitted4
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: DropdownFormFieldString(
                    label: 'Mode of Payment',
                    onChanged: (value) {},
                    onSaved: (value) => setState(() => _MOP = value!),
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
                  ),
                ),
              ],
            ),
          ),
        ];

    return Scaffold(
      appBar: AppBarDefault(
        title: 'Make Appointment',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 0,
        ),
        child: Stepper(
          // margin: EdgeInsets.symmetric(
          //   vertical: defaultPadding,
          //   horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : defaultPadding,
          // ),
          type: StepperType.horizontal,
          currentStep: _activeStepIndex,
          steps: stepList(),
          onStepContinue: () async {
            final isLastStep = _activeStepIndex == stepList().length - 1;

            if (isLastStep) {
              submit();
            } else if (_activeStepIndex == 0) {
              if (_dateTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  snackBarDefault(
                    text: 'Please choose an appointment date and time',
                    fontSize: 16,
                  ),
                );
              } else {
                setState(() {
                  _activeStepIndex += 1;
                });
              }
            } else if (_activeStepIndex == 1) {
              submit2();
            } else if (_activeStepIndex == 2) {
              submit3();
            } else {
              setState(() {
                _activeStepIndex += 1;
              });
            }
          },
          // onStepTapped: (step) => setState(() {
          //   _activeStepIndex = step;
          // }),
          onStepCancel: () {
            if (_activeStepIndex != 0) {
              setState(() {
                _activeStepIndex -= 1;
              });
            }
          },
          controlsBuilder: (context, ControlsDetails detail) {
            final isLastStep = _activeStepIndex == stepList().length - 1;

            return Container(
              margin: const EdgeInsets.only(top: defaultPadding),
              child: Row(
                children: [
                  if (_activeStepIndex != 0) ...[
                    Expanded(
                      child: ButtonTextDefault(
                        text: 'BACK',
                        press: detail.onStepCancel,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                  ],
                  Expanded(
                    child: ButtonTextDefault(
                      text: isLastStep
                          ? (isLoading ? 'LOADING..' : 'CONFIRM')
                          : 'NEXT',
                      press: detail.onStepContinue,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // SingleChildScrollView(
      //   scrollDirection: Axis.vertical,
      //   child: Container(
      //     padding: const EdgeInsets.fromLTRB(
      //         defaultPadding, defaultPadding, defaultPadding, 0),
      //     child: Column(
      //       children: [
      //         DoctorLongCard(
      //           doctor: widget.doctor,
      //           press: () {},
      //         ),
      //         const SizedBox(height: defaultPadding),
      //         _buildDescription(),
      //         const SizedBox(height: defaultPadding),
      //         _buildFee(),
      //         const SizedBox(height: defaultPadding),
      //         _buildDateTime(),
      //       ],
      //     ),
      //   ),
      // ),
      // bottomNavigationBar: Container(
      //   margin: const EdgeInsets.all(defaultPadding),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(defaultBorderRadius),
      //     child: Material(
      //       color: kPrimaryColor,
      //       child: InkWell(
      //         onTap: () {
      //           setState(() => _submitted = true);
      //           final isValid = _formKey.currentState?.validate();
      //           FocusScope.of(context).unfocus();
      //           if (isValid!) {
      //             _formKey.currentState?.save();
      //           }
      //         },
      //         child: Container(
      //           alignment: Alignment.center,
      //           width: MediaQuery.of(context).size.width,
      //           height: 60,
      //           child: const Text(
      //             "Book an Appointment",
      //             style: TextStyle(
      //               fontSize: 18,
      //               color: Colors.white,
      //               fontWeight: FontWeight.w500,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
