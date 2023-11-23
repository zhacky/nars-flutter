import 'package:nars/api/set_pin.dart';
import 'package:nars/components/alert_dialog_default.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/user/change_pin_param.dart';
import 'package:nars/screens/pincode/pincode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChangePINScreen extends StatefulWidget {
  const ChangePINScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePINScreen> createState() => _ChangePINScreenState();
}

class _ChangePINScreenState extends State<ChangePINScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  String _oldPinCode = '';
  String _pinCode = '';
  String _retypePinCode = '';
  TextEditingController oldPinCodeController = TextEditingController(text: '');
  TextEditingController pinCodeController = TextEditingController(text: '');
  TextEditingController retypePinCodeController =
      TextEditingController(text: '');

  Future<void> submit() async {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      EasyLoading.show(status: 'loading...');
      _formKey.currentState?.save();

      var _response = await SetPinApi.changePin(
        ChangePinParam(
          oldPin: _oldPinCode,
          newPin: _pinCode,
        ),
      );
      print('_response');
      print(_response);
      if (_response.statusCode == 200) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarDefault(text: _response.body),
        );
      }
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // String _pinCode = widget.profile?.information.pinCode ?? '';

    Widget _buildOldPINCodeField() {
      return GestureDetector(
        onTap: () async {
          final data = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PincodeScreen(
                callback: (code) {
                  Navigator.pop(context, code);
                },
              ),
            ),
          );

          _oldPinCode = data;
          oldPinCodeController.text = data;
        },
        child: AbsorbPointer(
          child: InputFormField(
            label: 'Old PIN Code',
            obscureText: true,
            textEditingController: oldPinCodeController,
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

    Widget _buildPINCodeField() {
      return GestureDetector(
        onTap: () async {
          final data = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PincodeScreen(
                callback: (code) {
                  Navigator.pop(context, code);
                },
              ),
            ),
          );

          _pinCode = data;
          pinCodeController.text = data;
        },
        child: AbsorbPointer(
          child: InputFormField(
            label: 'New PIN Code',
            obscureText: true,
            textEditingController: pinCodeController,
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

    Widget _buildRetypePINCodeField() {
      return GestureDetector(
        onTap: () async {
          final data = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PincodeScreen(
                callback: (code) {
                  Navigator.pop(context, code);
                },
              ),
            ),
          );

          _retypePinCode = data;
          retypePinCodeController.text = data;
        },
        child: AbsorbPointer(
          child: InputFormField(
            label: 'Retype New PIN Code',
            obscureText: true,
            textEditingController: retypePinCodeController,
            onSaved: (value) {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required';
              } else if (value != _pinCode) {
                return "PIN Code didn't match";
              } else {
                return null;
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarDefault(title: 'Change PIN'),
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
                _buildOldPINCodeField(),
                const SizedBox(height: defaultPadding),
                _buildPINCodeField(),
                const SizedBox(height: defaultPadding),
                _buildRetypePINCodeField(),
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
                submit();
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
