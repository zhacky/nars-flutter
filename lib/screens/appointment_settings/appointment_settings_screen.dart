import 'package:nars/api/practitioner_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/practitioner/edit_practitioner_param.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:flutter/material.dart';

class AppointmentSettingsScreen extends StatefulWidget {
  const AppointmentSettingsScreen({
    Key? key,
    required this.practitioner,
  }) : super(key: key);

  final Practitioner practitioner;

  @override
  State<AppointmentSettingsScreen> createState() =>
      _AppointmentSettingsScreenState();
}

class _AppointmentSettingsScreenState extends State<AppointmentSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  bool _isLoading = false;

  Practitioner? _practitioner;

  void submit(Practitioner param) async {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      setState(() => _isLoading = true);
      _formKey.currentState?.save();

      debugPrint('Practitioner: ${practitionerToJson(param)}');
      var result = await PractitionerApi.editPractitioner(
        EditPractitionerProfileParam(
          id: param.id!,
          practitionerProfile: param,
        ),
      );
      debugPrint('Result body: ${result.body}');
      debugPrint('Result statusCode: ${result.statusCode}');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Column(
            children: [
              Text(
                "Done",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          content: const Text('Saved Successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(param);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );

      // if (result.statusCode == 200) {

      // } else {
      //   var snackBar = const SnackBar(
      //     content: Text(
      //       'Something went wrong, please try again.',
      //       style: TextStyle(
      //         fontSize: 20,
      //       ),
      //     ),
      //     backgroundColor: Colors.redAccent,
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
    }
  }

  //initState
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Practitioner _practitioner = widget.practitioner;

    Widget _buildConsultationDurationField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consultation Duration (Minute)',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(height: defaultPadding / 2),
          InputFormField(
            label: '',
            initialValue: _practitioner.consultationMinute.toString(),
            onSaved: (value) => setState(
                () => _practitioner.consultationMinute = int.parse(value!)),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
        ],
      );
    }

    Widget _buildConsultationFeeField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consultation Fee',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(height: defaultPadding / 2),
          InputFormField(
            label: '',
            initialValue: _practitioner.consultationFee.toString(),
            onSaved: (value) => setState(
                () => _practitioner.consultationFee = double.parse(value!)),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
        ],
      );
    }

    Widget _buildMedcertFeeField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medcert Fee',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(height: defaultPadding / 2),
          InputFormField(
            label: '',
            initialValue: _practitioner.medcertFee == null
                ? ''
                : _practitioner.medcertFee.toString(),
            onSaved: (value) =>
                setState(() => _practitioner.medcertFee = double.parse(value!)),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBarDefault(title: 'Appointment Settings'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                const SizedBox(height: defaultPadding),
                _buildConsultationDurationField(),
                const SizedBox(height: defaultPadding),
                _buildConsultationFeeField(),
                const SizedBox(height: defaultPadding),
                _buildMedcertFeeField(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: defaultPadding,
          horizontal: Responsive.isDesktop(context)
              ? size.width * 0.30
              : defaultPadding,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: Material(
            color: kPrimaryColor,
            child: InkWell(
              onTap: () {
                submit(_practitioner);
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
