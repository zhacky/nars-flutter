import 'package:nars/api/appointment_api.dart';
import 'package:nars/components/alert_dialog_default.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/container_loading_indicate.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/appointment/appointment_detail.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DoctorNoteScreen extends StatefulWidget {
  const DoctorNoteScreen({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  State<DoctorNoteScreen> createState() => _DoctorNoteScreenState();
}

class _DoctorNoteScreenState extends State<DoctorNoteScreen> {
  Appointment? _appointment;
  late AppointmentDetail _appointmentDetail;
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
    // _appointmentDetail = _appointment.appointmentDetail;
    if (_appointment?.appointmentDetail != null) {
      _appointmentDetail = _appointment!.appointmentDetail!;
      _appointmentDetail.id = _appointment!.id;
    } else {
      _appointmentDetail = AppointmentDetail(
        appointmentId: _appointment!.id,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submit() async {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid!) {
      setState(() => _isLoading = true);
      _formKey.currentState?.save();
      Response result;
      if (_appointment?.appointmentDetail != null) {
        debugPrint(
            'EditappointmentDetailToJson: ${appointmentDetailToJson(_appointmentDetail)}');
        result = await AppointmentApi.editAppointmentDetail(_appointmentDetail);
      } else {
        debugPrint(
            'AddappointmentDetailToJson: ${appointmentDetailToJson(_appointmentDetail)}');
        result = await AppointmentApi.addAppointmentDetail(_appointmentDetail);
      }

      if (result.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialogDefault(
            press: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        );
      } else {
        print(result.body);
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarDefault(),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Widget _buildVitalSignField() {
    return InputFormField(
      label: 'Vital Signs',
      initialValue: _appointmentDetail.vitalSigns,
      textInputType: TextInputType.multiline,
      minLines: 2,
      maxLines: 10,
      onSaved: (value) => setState(
          () => _appointmentDetail.vitalSigns = value == '' ? null : value),
      validator: (value) {
        return null;
      },
    );
  }

  Widget _buildChiefComplaintField() {
    return InputFormField(
      label: 'Chief Complaint',
      initialValue: _appointmentDetail.chiefComplaint,
      textInputType: TextInputType.multiline,
      minLines: 2,
      maxLines: 10,
      onSaved: (value) => setState(
          () => _appointmentDetail.chiefComplaint = value == '' ? null : value),
      validator: (value) {
        return null;
      },
    );
  }

  Widget _buildSubjectiveField() {
    return InputFormField(
      label: 'Subjective',
      initialValue: _appointmentDetail.subjective,
      textInputType: TextInputType.multiline,
      minLines: 2,
      maxLines: 10,
      onSaved: (value) => setState(
          () => _appointmentDetail.subjective = value == '' ? null : value),
      validator: (value) {
        return null;
      },
    );
  }

  Widget _buildObjectiveField() {
    return InputFormField(
      label: 'Objective',
      initialValue: _appointmentDetail.objective,
      textInputType: TextInputType.multiline,
      minLines: 2,
      maxLines: 10,
      onSaved: (value) => setState(
          () => _appointmentDetail.objective = value == '' ? null : value),
      validator: (value) {
        return null;
      },
    );
  }

  Widget _buildAssessmentField() {
    return InputFormField(
      label: 'Assessment',
      initialValue: _appointmentDetail.assessment,
      textInputType: TextInputType.multiline,
      minLines: 2,
      maxLines: 10,
      onSaved: (value) =>
          setState(() => _appointmentDetail.assessment = value!),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildPlanField() {
    return InputFormField(
      label: 'Plan',
      initialValue: _appointmentDetail.plan,
      textInputType: TextInputType.multiline,
      minLines: 2,
      maxLines: 10,
      onSaved: (value) =>
          setState(() => _appointmentDetail.plan = value == '' ? null : value),
      validator: (value) {
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarDefault(title: "Doctor's Note"),
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
              children: [
                // const SectionTitle(title: 'Address'),
                const SizedBox(height: defaultPadding),
                _buildVitalSignField(),
                const SizedBox(height: defaultPadding),
                _buildChiefComplaintField(),
                const SizedBox(height: defaultPadding),
                _buildSubjectiveField(),
                const SizedBox(height: defaultPadding),
                _buildObjectiveField(),
                const SizedBox(height: defaultPadding),
                _buildAssessmentField(),
                const SizedBox(height: defaultPadding),
                _buildPlanField(),
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
                      child: ContainerLoadingIndicator(
                        isLoading: _isLoading,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
