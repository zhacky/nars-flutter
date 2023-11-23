import 'package:nars/api/appointment_api.dart';
import 'package:nars/api/medcert_api.dart';
import 'package:nars/components/alert_dialog_default.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/models/appointment/appointment_detail.dart';
import 'package:nars/screens/in_app_browser/in_app_browser_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MedcertRemarkScreen extends StatefulWidget {
  const MedcertRemarkScreen({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  State<MedcertRemarkScreen> createState() => _MedcertRemarkScreenState();
}

class _MedcertRemarkScreenState extends State<MedcertRemarkScreen> {
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

  void _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication))
      throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    // String? _remark = _appointment?.appointmentDetail?.remarks;
    final flavor = Provider.of<Flavor>(context);
    Size size = MediaQuery.of(context).size;

    Widget _buildRemarkField() {
      return InputFormField(
        label: 'Medical Certificate Remark',
        initialValue: _appointmentDetail.remarks,
        textInputType: TextInputType.multiline,
        minLines: 4,
        maxLines: 10,
        onSaved: (value) => setState(
            () => _appointmentDetail.remarks = value == '' ? null : value),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else {
            return null;
          }
        },
      );
    }

    Widget _buildRemark() {
      return Text(_appointmentDetail.remarks ?? '');
    }

    return Scaffold(
      appBar: AppBarDefault(title: 'Medical Certificate'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
            horizontal: Responsive.isDesktop(context)
                ? size.width * 0.30
                : defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SectionTitle(title: 'Address'),
              const SizedBox(height: defaultPadding),

              if (flavor == Flavor.Practitioner) ...[
                Form(
                  key: _formKey,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: _buildRemarkField(),
                ),
              ] else ...[
                _buildRemark(),
              ],
              const SizedBox(height: defaultPadding),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(defaultBorderRadius),
                ),
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () async {
                      var result = await MedcertApi.generateMedcert(
                          widget.appointment.id);
                      _launchUrl(Uri.parse(result.link));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      child: const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 18,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (flavor == Flavor.Practitioner) ...[
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
                      child: Container(
                        alignment: Alignment.center,
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
