import 'package:nars/api/hospital_api.dart';
import 'package:nars/api/practitioner_hospital_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/button_default.dart';
import 'package:nars/components/container_loading_indicate.dart';
import 'package:nars/components/dropdown_form_field_int.dart';
import 'package:nars/components/dropdown_form_field_string.dart';
import 'package:nars/components/button_text_field.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/components/subtitle.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/practitioner/add_practitioner_hospital_schedule_param.dart';
import 'package:nars/models/practitioner/edit_practitioner_hospital_schedule_param.dart';
import 'package:nars/models/hospital/hospital.dart';
import 'package:nars/models/hospital/hospital_schedule.dart';
import 'package:nars/models/hospital/hospital_schedule_timespan.dart';
import 'package:nars/models/practitioner/practitioner_hospital.dart';
import 'package:nars/providers/practitioner_hospital_provider.dart';
import 'package:nars/screens/hospital_form/hospital_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class HospitalScheduleFormScreen extends StatefulWidget {
  const HospitalScheduleFormScreen({
    Key? key,
    this.practitionerHospital,
  }) : super(key: key);

  final PractitionerHospital? practitionerHospital;

  @override
  State<HospitalScheduleFormScreen> createState() =>
      _HospitalScheduleFormScreenState();
}

class _HospitalScheduleFormScreenState
    extends State<HospitalScheduleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  bool isLoading = false;
  int? _hospital;
  List<Hospital>? hospitals;
  late PractitionerHospital pH;
  // late List<HospitalSchedule> lHS;

  Future getHospitals() async {
    var result = await HospitalApi.getHospitals();

    setState(() {
      hospitals = result;
      if (widget.practitionerHospital != null) {
        // print('init practitionerHospitals');
        // print(practitionerHospitalToJson(widget.practitionerHospital!));
        _hospital = widget.practitionerHospital!.hospitalId;
        // print('init widget.practitionerHospital!');
        // print(practitionerHospitalToJson(widget.practitionerHospital!));
      }
    });
  }

  void submit() async {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      setState(() => isLoading = true);
      _formKey.currentState?.save();

      // print('updated pH.id');
      // print(pH.id);

      // print('updated hospitalSchedules');
      // print(hospitalScheduleToJson(pH.hospitalSchedule));

      if (pH.hospitalSchedule.any((x) => x.hospitalScheduleTimeSpans
          .any((y) => y.start == null || y.end == null))) {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarDefault(
            text: 'Please fill out all the field',
          ),
        );
        setState(() => isLoading = false);
      } else {
        Response result;
        if (widget.practitionerHospital != null) {
          result =
              await PractitionerHospitalApi.editPractitionerHospitalSchedule(
            EditPractitionerHospitalScheduleParam(
              practitionerHospitalId: pH.id!,
              hospitalSchedules: pH.hospitalSchedule,
            ),
          );
        } else {
          // print('practitionerHospitalToJson(pH)');
          // print(practitionerHospitalToJson(pH));
          result =
              await PractitionerHospitalApi.addPractitionerHospitalSchedule(
            AddPractitionerHospitalScheduleParam(
              hospitalId: _hospital!,
              hospitalSchedules: pH.hospitalSchedule,
            ),
          );
        }

        // print('EditPractitionerHospitalSchedule response123');
        // print(result);

        if (result.statusCode == 204) {
          Navigator.of(context).pop();
        } else {
          print('Something went wrong, please try again');
          print(result.body);
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarDefault(),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getHospitals();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget _buildHospitalField() {
      return DropdownFormFieldInt(
        label: 'Hospital',
        onChanged: (value) => setState(() {
          _hospital = value!;
        }),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: _hospital,
        values: hospitals?.map((x) {
          return DropdownMenuItem(
            child: Text(x.name),
            value: x.id,
          );
        }).toList(),
      );
    }

    Widget _buildDayField(PractitionerHospitalProvider model, bool deleteMode,
        HospitalSchedule hS) {
      return Row(
        children: [
          Expanded(
            child: DropdownFormFieldString(
              label: 'Day',
              onChanged: (value) {
                setState(() {
                  var result = model.changeDay(hS.id!, value);
                  if (result != null) {
                    // value = null;
                    hS.day = null;
                    // value = 'Sunday';
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBarDefault(
                        text: result,
                      ),
                    );
                  }
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'This field is required';
                } else {
                  return null;
                }
              },
              value: hS.day,
              values: getDays(),
            ),
          ),
          if (deleteMode) ...[
            const SizedBox(width: defaultPadding),
            ButtonDefault(
              width: (Responsive.isDesktop(context)
                      ? size.width * 0.30
                      : size.width) /
                  7,
              bgColor: Colors.redAccent,
              svgScr: 'assets/icons/trash.svg',
              press: () {
                model.deleteDay(hS.id!);
              },
            ),
          ],
        ],
      );
    }

    Widget _buildStartTimeField(PractitionerHospitalProvider model,
        bool deleteMode, HospitalSchedule hS, HospitalScheduleTimeSpan hSTS) {
      return ButtonTextField(
        label: 'Start Time',
        title: hSTS.start?.format(context),
        leftPadding: deleteMode ? 18 : 24,
        press: () async {
          FocusScope.of(context).unfocus();
          TimeOfDay? _time = await showTimePicker(
            context: context,
            initialTime: hSTS.start != null
                ? hSTS.start!
                : const TimeOfDay(hour: 8, minute: 0),
          );
          if (_time != null) {
            setState(() {
              model.changeStartTime(hS.id!, hSTS.id!, _time);
            });
          }
        },
      );
    }

    Widget _buildEndTimeField(PractitionerHospitalProvider model,
        bool deleteMode, HospitalSchedule hS, HospitalScheduleTimeSpan hSTS) {
      return ButtonTextField(
        label: 'End Time',
        title: hSTS.end?.format(context),
        leftPadding: deleteMode ? 18 : 24,
        press: () async {
          FocusScope.of(context).unfocus();
          TimeOfDay? _time = await showTimePicker(
            context: context,
            initialTime: hSTS.end != null
                ? hSTS.end!
                : const TimeOfDay(hour: 12, minute: 0),
          );
          if (_time != null) {
            setState(() {
              model.changeEndTime(hS.id!, hSTS.id!, _time);
            });
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBarDefault(title: 'Add Hospital & Schedules'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
            horizontal: Responsive.isDesktop(context)
                ? size.width * 0.30
                : defaultPadding,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildHospitalField(),
                const SizedBox(height: defaultPadding),
                ButtonDefault(
                  width: (Responsive.isDesktop(context)
                          ? size.width * 0.30
                          : size.width) /
                      2.5,
                  bgColor: kPrimaryColor,
                  title: 'Request a Hospital',
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HospitalFormScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: defaultPadding),
                // if (widget.practitionerHospital != null)
                ChangeNotifierProvider(
                  create: (context) => PractitionerHospitalProvider(
                      widget.practitionerHospital?.id),
                  child: Builder(
                    builder: (context) {
                      final model =
                          Provider.of<PractitionerHospitalProvider>(context);
                      if (model.homeState == HomeState.Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (model.homeState == HomeState.Error) {
                        return Center(
                          child: Text(
                              'Something went wrong, please try again.\n${model.message}'),
                        );
                      }
                      pH = model.practitionerHospital;
                      var lHS = pH.hospitalSchedule;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SubtitleDefault(title: 'Schedules'),
                              TextButton(
                                onPressed: () {
                                  model.deleteMode();
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              )
                            ],
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: lHS.length,
                            itemBuilder: (cHS, iHS) {
                              final hS = lHS[iHS];
                              return Column(
                                children: [
                                  if (iHS != 0) const Divider(),
                                  const SizedBox(height: defaultPadding),
                                  _buildDayField(model, pH.deleteMode, hS),
                                  const SizedBox(height: defaultPadding),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        hS.hospitalScheduleTimeSpans.length,
                                    itemBuilder: (cHSTS, iHSTS) {
                                      final hSTS =
                                          hS.hospitalScheduleTimeSpans[iHSTS];
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              if (iHSTS ==
                                                  hS.hospitalScheduleTimeSpans
                                                          .length -
                                                      1) ...[
                                                ButtonDefault(
                                                  svgScr:
                                                      'assets/icons/plus.svg',
                                                  width: (Responsive.isDesktop(
                                                              context)
                                                          ? size.width * 0.30
                                                          : size.width) *
                                                      0.15,
                                                  press: () {
                                                    model.addScheduleTimeSpan(
                                                        hS.id!);
                                                  },
                                                ),
                                              ] else ...[
                                                SizedBox(
                                                  width: (Responsive.isDesktop(
                                                              context)
                                                          ? size.width * 0.30
                                                          : size.width) *
                                                      0.15,
                                                )
                                              ],
                                              const SizedBox(
                                                  width: defaultPadding),
                                              Expanded(
                                                child: _buildStartTimeField(
                                                    model,
                                                    pH.deleteMode,
                                                    hS,
                                                    hSTS),
                                              ),
                                              const SizedBox(
                                                  width: defaultPadding),
                                              Expanded(
                                                child: _buildEndTimeField(model,
                                                    pH.deleteMode, hS, hSTS),
                                              ),
                                              if (pH.deleteMode &&
                                                  hS.hospitalScheduleTimeSpans
                                                          .length !=
                                                      1) ...[
                                                const SizedBox(
                                                    width: defaultPadding),
                                                ButtonDefault(
                                                  width: (Responsive.isDesktop(
                                                              context)
                                                          ? size.width * 0.30
                                                          : size.width) /
                                                      7,
                                                  bgColor: Colors.redAccent,
                                                  svgScr:
                                                      'assets/icons/trash.svg',
                                                  press: () {
                                                    model
                                                        .deleteScheduleTimeSpan(
                                                            hS.id!, hSTS.id!);
                                                  },
                                                ),
                                              ],
                                            ],
                                          ),
                                          if (iHSTS !=
                                              hS.hospitalScheduleTimeSpans
                                                      .length -
                                                  1)
                                            const SizedBox(
                                                height: defaultPadding),
                                        ],
                                      );
                                    },
                                  ),
                                  if (iHS != lHS.length - 1)
                                    const SizedBox(height: defaultPadding),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: defaultPadding),
                          if (!model.practitionerHospital.allDayExist)
                            ButtonDefault(
                              width: (Responsive.isDesktop(context)
                                      ? size.width * 0.30
                                      : size.width) /
                                  3,
                              bgColor: Colors.green.shade400,
                              title: 'Add Day',
                              press: () {
                                model.addDay();
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),
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
                if (widget.practitionerHospital != null) ...[
                  const SizedBox(height: defaultPadding),
                  ButtonDefault(
                    width: (Responsive.isDesktop(context)
                            ? size.width * 0.30
                            : size.width) /
                        3,
                    fontColor: Colors.redAccent,
                    bgColor: Colors.white,
                    title: 'Delete Hospital',
                    press: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Delete',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          content: const Text(
                              'Are you sure you want to delete this hospital on your profile?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();

                                var result = await PractitionerHospitalApi
                                    .deletePractitionerHospitalSchedule(
                                        widget.practitionerHospital!.id!);

                                if (result.statusCode == 204) {
                                  Navigator.of(context).pop();
                                } else {
                                  print(
                                      'Something went wrong, please try again');
                                  print(result.body);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarDefault(),
                                  );
                                }
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
