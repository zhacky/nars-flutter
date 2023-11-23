import 'package:nars/api/prescription_api.dart';
import 'package:nars/components/alert_dialog_default.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/container_loading_indicate.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/prescription/prescription.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PrescriptionFormScreen extends StatefulWidget {
  const PrescriptionFormScreen({
    Key? key,
    required this.appointmentId,
    this.prescription,
  }) : super(key: key);

  final int appointmentId;
  final Prescription? prescription;

  @override
  State<PrescriptionFormScreen> createState() => _PrescriptionFormScreenState();
}

class _PrescriptionFormScreenState extends State<PrescriptionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  bool _isLoading = false;
  bool _deleteIsLoading = false;
  late Prescription _prescription;

  @override
  void initState() {
    super.initState();
    if (widget.prescription != null) {
      _prescription = widget.prescription!;
      _prescription.appointmentId = widget.appointmentId;
    } else {
      _prescription = Prescription(
        appointmentId: widget.appointmentId,
        drugName: '',
        dosage: '',
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> submit() async {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      setState(() => _isLoading = true);
      _formKey.currentState?.save();

      Response result;
      if (widget.prescription == null) {
        result = await PrescriptionApi.addPrescription(_prescription);
      } else {
        result = await PrescriptionApi.editPrescription(_prescription);
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
        debugPrint(result.body);
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarDefault(),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> delete() async {
    setState(() => _deleteIsLoading = true);
    // await Future.delayed(const Duration(seconds: 5));
    var result =
        await PrescriptionApi.deletePrescription(widget.prescription!.id!);
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
      debugPrint(result.body);
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarDefault(),
      );
    }
    setState(() => _deleteIsLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget _buildNameField() {
      return InputFormField(
        label: 'Drug Name',
        hintText: '(eg. paracetamol, Biogesic)',
        initialValue: _prescription.drugName,
        onSaved: (value) => setState(() => _prescription.drugName = value!),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else {
            return null;
          }
        },
      );
    }

    Widget _buildPreparationField() {
      return InputFormField(
        label: 'Preparation',
        initialValue: _prescription.preparation,
        onSaved: (value) => setState(
            () => _prescription.preparation = value == '' ? null : value),
        validator: (value) {
          return null;
        },
      );
    }

    Widget _buildDosageField() {
      return InputFormField(
        label: 'Dosage',
        hintText: '(eg. 3x a day, every 4hrs)',
        initialValue: _prescription.dosage,
        onSaved: (value) => setState(() => _prescription.dosage = value!),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else {
            return null;
          }
        },
      );
    }

    Widget _buildDurationField() {
      return InputFormField(
        label: 'Duration',
        initialValue: _prescription.duration,
        onSaved: (value) =>
            setState(() => _prescription.duration = value == '' ? null : value),
        validator: (value) {
          return null;
        },
      );
    }

    Widget _buildQuantityField() {
      return InputFormField(
        label: 'Quantity',
        hintText: '(eg. 10 pill, 2 tab)',
        initialValue: _prescription.quantity,
        onSaved: (value) => setState(() => _prescription.quantity = value == ''
            ? null
            : value == ''
                ? null
                : value),
        validator: (value) {
          return null;
        },
      );
    }

    return Scaffold(
      appBar: AppBarDefault(
        title: (widget.prescription != null
            ? 'Edit Prescription'
            : 'Add New Prescription'),
      ),
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
                const SectionTitle(title: 'Prescription'),
                const SizedBox(height: defaultPadding),
                _buildNameField(),
                const SizedBox(height: defaultPadding),
                _buildPreparationField(),
                const SizedBox(height: defaultPadding),
                _buildDosageField(),
                const SizedBox(height: defaultPadding),
                _buildDurationField(),
                const SizedBox(height: defaultPadding),
                _buildQuantityField(),
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
                        label: 'Save',
                      ),
                    ),
                  ),
                ),
                if (widget.prescription != null) ...[
                  const SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadius),
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                delete();
                              },
                              child: ContainerLoadingIndicator(
                                isLoading: _deleteIsLoading,
                                label: 'Delete',
                                loadingText: 'Deleting..',
                                labelColor: Colors.redAccent,
                              ),
                              // Container(
                              //   padding: const EdgeInsets.all(defaultPadding),
                              //   alignment: Alignment.center,
                              //   child: Text(
                              //     'Delete',
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .subtitle1!
                              //         .copyWith(color: Colors.redAccent),
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 5,
                        child: SizedBox.shrink(),
                      )
                    ],
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
