import 'package:nars/api/appointment_api.dart';
import 'package:nars/api/hospital_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/components/container_loading_indicate.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/components/time_button.dart';
import 'package:nars/components/title_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/appointment/get_appointment_by_practitioner_id_param.dart';
import 'package:nars/models/appointment/resched_appointment_param.dart';
import 'package:nars/models/common/date_filter.dart';
import 'package:nars/models/demo/event_demo.dart';
import 'package:nars/models/hospital/hospital_schedule.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/models/practitioner/practitioner_hospital.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class RescheduleScreen extends StatefulWidget {
  const RescheduleScreen({Key? key, required this.appointment})
      : super(key: key);

  final Appointment appointment;

  @override
  State<RescheduleScreen> createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  bool isLoading = false;

  late Stream<List<Appointment>> appointmentsStream;
  List<DateTime>? _occupieds;
  late final ValueNotifier<List<Event>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _time;
  DateTime? _dateTime;
  String _reason = '';

  late Stream<List<PractitionerHospital>> hospitalsStream;

  Stream<List<PractitionerHospital>> getPractitionerHospitals(
      int practitionerId, String day) async* {
    yield await HospitalApi.getPractitionerHospitalsWithDay(
        practitionerId, day);
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    appointmentsStream = getappointments(_selectedDay!);
    hospitalsStream = getPractitionerHospitals(
        widget.appointment.practitionerId!,
        DateFormat('EEEE').format(DateTime.now()));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  Stream<List<Appointment>> getappointments(DateTime selectedDay) async* {
    var start = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    var data = await AppointmentApi.getPractitionerAppointments(
      GetAppointmentByPractitionerIdParam(
        practitionerId: 2,
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      appointmentsStream = getappointments(_selectedDay!);
      hospitalsStream = getPractitionerHospitals(
          widget.appointment.practitionerId!,
          DateFormat('EEEE').format(selectedDay));
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flavor = Provider.of<Flavor>(context);
    Size size = MediaQuery.of(context).size;
    var _firstDay = DateTime.now();
    var _lastDay = DateTime(_firstDay.year, _firstDay.month + 3, _firstDay.day);

    var _curDateTime = _focusedDay.month == DateTime.now().month &&
            _focusedDay.day == DateTime.now().day
        ? DateTime.now()
        : _focusedDay;
    var _openTime = const TimeOfDay(hour: 8, minute: 0);
    var _closeTime = const TimeOfDay(hour: 20, minute: 0);
    var _curOpenTime = timeToInt(_openTime) < dateToInt(_curDateTime)
        ? _curDateTime
        : DateTime(_curDateTime.year, _curDateTime.month, _curDateTime.day,
            _openTime.hour, _openTime.minute);

    var _endOfTheDay = DateTime(_curDateTime.year, _curDateTime.month,
        _curDateTime.day, _closeTime.hour, _closeTime.minute);
    var _roundedTime = _curOpenTime.roundMin;

    int _totalMinute = _endOfTheDay.difference(_roundedTime).inMinutes;
    int slots = _totalMinute > 0 ? (_totalMinute / 30).round() : 0;

    Future<void> submit() async {
      setState(() => _submitted = true);
      final isValid = _formKey.currentState?.validate();
      FocusScope.of(context).unfocus();

      if (isValid!) {
        setState(() => isLoading = true);
        _formKey.currentState?.save();

        if (_dateTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarDefault(
              text: 'Please choose an appointment date and time',
              fontSize: 16,
            ),
          );
          setState(() => isLoading = false);
        } else {
          var result = await AppointmentApi.reschedAppointment(
            ReschedAppointmentParam(
              appointmentId: widget.appointment.id,
              dateTime: _dateTime!,
              rescheduleReason: _reason,
            ),
          );
          if (result.statusCode == 200) {
            setState(() => isLoading = false);
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
                      "Appointment successfully re-scheduled",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                content: Text(
                    'Please wait for the approval of the ${flavor == Flavor.Patient ? 'Doctor' : 'Patient'}, thank you.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         const MainPatientScreen(),
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
              snackBarDefault(),
            );
          }
        }

        setState(() => isLoading = false);
        // try {
        //   var result = await DocumentApi.uploadDocument(
        //       image!, _type!.index, _other ?? '');

        //   // print('result');
        //   // print(result);
        //   Navigator.of(context).pop();
        // } catch (e) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     snackBarDefault(
        //       'Something went wrong, please try again',
        //       fontSize: 20,
        //     ),
        //   );
        //   print(e);
        // } finally {
        //   setState(() {
        //     isLoading = false;
        //   });
        // }
      }
    }

    Widget _buildDateTime() {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleDefault(
                title: 'When would you like to re-schedule this appointment?'),
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
                // if (_calendarFormat != format) {
                //   setState(() {
                //     _calendarFormat = format;
                //   });
                // }
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
            StreamBuilder(
              stream: appointmentsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Appointment>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Appointment> appointments = snapshot.data!;
                  _occupieds = appointments.map((e) => e.schedule).toList();
                  debugPrint("_occupieds: ${_occupieds}");
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
            // Wrap(
            //   direction: Axis.horizontal,
            //   spacing: defaultPadding,
            //   runSpacing: defaultPadding,
            //   children: List.generate(
            //     slots,
            //     (index) => TimeButton(
            //       label: DateFormat('h:mm a').format(
            //         _roundedTime.plusThirty(index),
            //       ),
            //       // time: ,
            //       index: index,
            //       selectedIndex: _time,
            //       press: () {
            //         setState(() {
            //           _time = index;
            //           _dateTime = _roundedTime.plusThirty(index);
            //         });

            //         // print('getTime: $getTime');
            //         print('index: $index');
            //         print('current time: $_curDateTime');
            //         print('roundedTime: $_roundedTime');
            //         print('endOfTheDay: $_endOfTheDay');
            //         print('minuteDif: $_totalMinute');
            //         print('slots: $slots');
            //         print('dateTime: $_dateTime');
            //       },
            //     ),
            //   ),
            // ),
            const TitleDefault(title: 'Time'),
            const SizedBox(height: defaultPadding),
            StreamBuilder(
              stream: hospitalsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<PractitionerHospital>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<PractitionerHospital> practitionerHospital =
                      snapshot.data!;
                  // debugPrint(
                  //     "practitionerHospital: ${getPractitionerHospitalsToJson(practitionerHospital)}");
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: practitionerHospital.length,
                    itemBuilder: (BuildContext context, int index) {
                      PractitionerHospital _data = practitionerHospital[index];
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

                            int _totalMinute =
                                _endOfTheDay.difference(_roundedTime).inMinutes;
                            int slots = _totalMinute > 0
                                ? (_totalMinute / 30).round()
                                : 0;

                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: defaultPadding),
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
                                      label: DateFormat('h:mm a').format(time),
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
            if (slots == 0)
              Text(
                'Today is already closed.',
                style: Theme.of(context).textTheme.titleMedium,
              )
          ],
        ),
      );
    }

    Widget _buildReason() {
      return CardContainer(
        child: Form(
          key: _formKey,
          autovalidateMode: _submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reason for re-scheduling',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: defaultPadding),
              InputFormField(
                label: '',
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
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarDefault(title: 'Re-schedule'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
            horizontal: Responsive.isDesktop(context)
                ? size.width * 0.30
                : defaultPadding,
          ),
          child: Column(
            children: [
              _buildDateTime(),
              const SizedBox(height: defaultPadding),
              _buildReason(),
              const SizedBox(height: defaultPadding),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(defaultBorderRadius),
                ),
                child: Material(
                  color: kPrimaryColor,
                  child: InkWell(
                    onTap: () {
                      submit();
                    },
                    child: ContainerLoadingIndicator(isLoading: isLoading),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
