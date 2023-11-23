import 'package:nars/api/otp_api.dart';
import 'package:nars/api/user_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/dropdown_form_field_int.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/components/text_button_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/enumerables/gender.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/information/information.dart';
import 'package:nars/models/patient/patient_profile.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:nars/models/user/user_acount.dart';
import 'package:nars/models/user/user_registration.dart';
import 'package:nars/screens/login/login_screen.dart';
import 'package:nars/screens/otp/otp_screen.dart';
import 'package:nars/screens/pincode/pincode_screen.dart';
import 'package:nars/screens/in_app_browser/in_app_browser_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _activeStepIndex = 0;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool _submitted1 = false;
  bool _submitted2 = false;
  bool loadOnce = true;

  String _firstName = '';
  String _middleName = '';
  String _lastName = '';
  String _phoneNumber = '';
  int _usertype = 2;
  int? _gender;
  DateTime? _birthDate;
  TextEditingController birthdateController = TextEditingController();

  String _email = '';
  String _pincode = '';
  String _retypepincode = '';
  TextEditingController pincodeController = TextEditingController();
  TextEditingController retypepincodeController = TextEditingController();
  String _prcNumber = '';
  bool _ToC = false;

  Widget _buildUsertype() {
    return DropdownFormFieldInt(
      label: 'User Type',
      onChanged: (value) {},
      onSaved: (value) => setState(() => _usertype = value!),
      validator: (value) {
        if (value == null) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      value: _usertype,
      values: getUsertypes(),
    );
  }

  Widget _buildFirstnameField() {
    return InputFormField(
      label: 'First Name',
      textInputAction: TextInputAction.next,
      onSaved: (value) => setState(() => _firstName = value!),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        } else if (!RegExp(r'^[a-z A-Z\-]+$').hasMatch(value)) {
          return 'Please input alphabets only';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildMiddlenameField() {
    return InputFormField(
      label: 'Middle Name',
      textInputAction: TextInputAction.next,
      onSaved: (value) => setState(() => _middleName = value!),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        } else if (!RegExp(r'^[a-z A-Z\-]+$').hasMatch(value)) {
          return 'Please input alphabets only';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildLastnameField() {
    return InputFormField(
      label: 'Last Name',
      textInputAction: TextInputAction.done,
      onSaved: (value) => setState(() => _lastName = value!),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        } else if (!RegExp(r'^[a-z A-Z\-]+$').hasMatch(value)) {
          return 'Please input alphabets only';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildBirthdateField() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        showDatePicker(
          context: context,
          initialDatePickerMode: DatePickerMode.year,
          initialDate: _birthDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ).then((date) => {
              setState(() {
                _birthDate = date;
                birthdateController.text =
                    DateFormat('MM/dd/yyyy').format(date ?? DateTime.now());
              }),
            });
      },
      child: AbsorbPointer(
        child: InputFormField(
          label: 'Date of Birth',
          hintText: 'MM/dd/yyyy',
          textEditingController: birthdateController,
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

  Widget _buildGenderField() {
    return DropdownFormFieldInt(
      label: 'Gender',
      onChanged: (value) {},
      onSaved: (value) => setState(() => _gender = value!),
      validator: (value) {
        if (value == null) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      value: _gender,
      values: getGenders(),
    );
  }

  Widget _buildPhonenumberField() {
    return InputFormField(
      label: 'Phone Number',
      hintText: '(09##)-###-####',
      formats: [phPhoneFormat],
      onSaved: (value) => setState(
          () => _phoneNumber = value!.replaceAll(RegExp(r'[^\w\s]+'), '')),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        } else if (value.length < 15) {
          return 'Phone number must be 11 digits';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildPRCNumberField() {
    return InputFormField(
      label: 'PRC Number',
      textInputAction: TextInputAction.next,
      onSaved: (value) => setState(() => _prcNumber = value!),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildEmailField() {
    return InputFormField(
      label: 'Email',
      onSaved: (value) => setState(() => _email = value!),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        } else if (!RegExp(
                r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)')
            .hasMatch(value)) {
          return 'Please input correct email format';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildPINCodeField() {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
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

        _pincode = data;
        pincodeController.text = data;
      },
      child: AbsorbPointer(
        child: InputFormField(
          label: 'Nominate PIN Code',
          obscureText: true,
          textEditingController: pincodeController,
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

        _retypepincode = data;
        retypepincodeController.text = data;
      },
      child: AbsorbPointer(
        child: InputFormField(
          label: 'Retype PIN Code',
          obscureText: true,
          textEditingController: retypepincodeController,
          onSaved: (value) {},
          validator: (value) {
            if (value!.isEmpty) {
              return 'This field is required';
            } else if (value != _pincode) {
              return "PIN Code didn't match";
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flavor = Provider.of<Flavor>(context);
    Size size = MediaQuery.of(context).size;

    dynamic sendOtp;
    List<Step> stepList() => [
          Step(
            state:
                _activeStepIndex <= 0 ? StepState.indexed : StepState.complete,
            isActive: _activeStepIndex >= 0,
            title: Text(_activeStepIndex == 0 ? 'Step 1' : ''),
            content: Form(
              key: _formKey1,
              autovalidateMode: _submitted1
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
                  if (flavor == Flavor.Practitioner) ...[
                    _buildUsertype(),
                    const SizedBox(height: defaultPadding),
                  ],
                  _buildFirstnameField(),
                  const SizedBox(height: defaultPadding),
                  _buildMiddlenameField(),
                  const SizedBox(height: defaultPadding),
                  _buildLastnameField(),
                  const SizedBox(height: defaultPadding),
                  _buildBirthdateField(),
                  const SizedBox(height: defaultPadding),
                  _buildGenderField(),
                  const SizedBox(height: defaultPadding),
                  _buildPhonenumberField(),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            ),
          ),
          Step(
            state: StepState.indexed,
            isActive: _activeStepIndex >= 1,
            title: Text(_activeStepIndex == 1 ? 'Step 2' : ''),
            content: Form(
              key: _formKey2,
              autovalidateMode: _submitted2
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
                  if (flavor == Flavor.Practitioner) ...[
                    _buildPRCNumberField(),
                    const SizedBox(height: defaultPadding),
                  ],
                  _buildEmailField(),
                  const SizedBox(height: defaultPadding),
                  _buildPINCodeField(),
                  const SizedBox(height: defaultPadding),
                  _buildRetypePINCodeField(),
                  CheckboxFormField(
                    title: RichText(
                      text: TextSpan(
                        text: 'Accept ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
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
                        ],
                      ),
                    ),
                    onSaved: (value) {},
                    validator: (value) {
                      if (value == false) {
                        return 'This field is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ];

    return Scaffold(
      appBar: AppBarDefault(title: 'Sign up'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 0,
        ),
        child: Stepper(
          type: StepperType.horizontal,
          elevation: 0,
          currentStep: _activeStepIndex,
          steps: stepList(),
          onStepContinue: () async {
            final isLastStep = _activeStepIndex == stepList().length - 1;
            int otpCode = 0;
            if (isLastStep) {
              setState(() => _submitted2 = true);
              final isValid2 = _formKey2.currentState?.validate();
              FocusScope.of(context).unfocus();
              // print("LABEL");
              // print(_firstName);
              if (isValid2!) {
                EasyLoading.show(status: 'loading...');
                _formKey2.currentState?.save();

                if (sendOtp == null
                    ? sendOtp == null
                    : sendOtp.statusCode == 401) loadOnce = true;
                if (loadOnce) {
                  sendOtp = await OtpApi.sendOtp(_phoneNumber, true);
                  if (sendOtp.statusCode != 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBarDefault(
                        text: sendOtp.body,
                      ),
                    );
                  } else
                    loadOnce = false;
                }

                print("STATUSCODE");
                print(sendOtp.statusCode);
                if (sendOtp.statusCode != 401) {
                  EasyLoading.dismiss();
                  var a = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(
                          title: 'OTP',
                          subtitle: 'An OTP has been sent to $_phoneNumber',
                          phonenumber: _phoneNumber,
                          loadOnce: loadOnce,
                          callback: (code) async {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         const SignUpStep2Screen(),
                            //   ),
                            // );

                            Navigator.pop(context, code);
                          },
                        ),
                      ));
                  otpCode = int.parse(a == null ? "0" : a);
                  if (a != null) {
                    var result = await UserApi.register(
                      UserRegistrationParam(
                        userType: flavor == Flavor.Patient ? 1 : _usertype,
                        patientProfile: flavor == Flavor.Patient
                            ? PatientProfile(
                                information: Information(
                                  firstName: _firstName,
                                  middleName: _middleName,
                                  lastName: _lastName,
                                  dateOfBirth: _birthDate!,
                                  gender: genderValues.map[_gender]!,
                                  phoneNumber: _phoneNumber,
                                ),
                              )
                            : null,
                        otpCode: otpCode,
                        userAccount: UserAccount(
                          phoneNumber: _phoneNumber,
                          email: _email,
                          pin: _pincode,
                        ),
                        practitionerProfile: flavor == Flavor.Practitioner
                            ? Practitioner(
                                yearOfExperience: 0,
                                consultationFee: 0,
                                consultationMinute: 30,
                                prc: _prcNumber,
                                isAvailable: true,
                                information: Information(
                                  firstName: _firstName,
                                  middleName: _middleName,
                                  lastName: _lastName,
                                  dateOfBirth: _birthDate!,
                                  gender: Gender.Male,
                                  phoneNumber: _phoneNumber,
                                ),
                              )
                            : null,
                      ),
                    );
                    // print('result.body');
                    // print(result.body);
                    sendOtp = result;
                    if (result.statusCode == 200) {
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
                                "You've successfully registered",
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          // content: const Text('Please wait for the approval of the Doctor, thank you.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Navigator.of(context).pop();

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const LoginScreen(),
                                //   ),
                                // );
                                Navigator.popUntil(
                                  context,
                                  ModalRoute.withName('/'),
                                );
                              },
                              child: const Text('Okay'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        snackBarDefault(
                          text: result.body,
                        ),
                      );
                    }
                  }
                }
                EasyLoading.dismiss();
              }
            } else {
              setState(() => _submitted1 = true);
              final isValid1 = _formKey1.currentState?.validate();
              FocusScope.of(context).unfocus();

              if (isValid1!) {
                _formKey1.currentState?.save();

                setState(() {
                  _activeStepIndex += 1;
                });

                // if (flavor != Flavor.Practitioner) {
                //   otpCode = int.parse(
                //     await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => PincodeScreen(
                //           title: 'OTP',
                //           subtitle: 'An OTP has been sent to $_phoneNumber',
                //           phonenumber: _phoneNumber,
                //           callback: (code) {
                //             // Navigator.push(
                //             //   context,
                //             //   MaterialPageRoute(
                //             //     builder: (context) =>
                //             //         const SignUpStep2Screen(),
                //             //   ),
                //             // );
                //             Navigator.pop(context, code);
                //           },
                //         ),
                //       ),
                //     ),
                //   );
                // }
              }
            }
          },
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
                      text: isLastStep ? 'SIGN UP' : 'NEXT',
                      press: detail.onStepContinue,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
