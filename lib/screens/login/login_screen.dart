import 'package:nars/components/already_have_an_account_check.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/user/auth.dart';
import 'package:nars/api/auth_service.dart';
import 'package:nars/screens/pincode/pincode_screen.dart';
import 'package:nars/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:nars/enumerables/flavor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _submitted = false;

  String _phonenumber = '';
  String _pincode = '';
  TextEditingController pincodeController = TextEditingController();

  Widget _buildPhonenumberField() {
    return InputFormField(
      label: 'Phone Number',
      hintText: '(09##)-###-####',
      formats: [phPhoneFormat],
      onSaved: (value) => setState(
          () => _phonenumber = value!.replaceAll(RegExp(r'[^\w\s]+'), '')),
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

  Widget _buildPINCodeField(Flavor flavor) {
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

        _pincode = data ?? '';
        pincodeController.text = data ?? '';
        submit(flavor);
      },
      child: AbsorbPointer(
        child: InputFormField(
          label: 'PIN Code',
          obscureText: true,
          textEditingController: pincodeController,
          onSaved: (value) => setState(() => _pincode = value!),
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

  void submit(Flavor flavor) async {
    setState(() {
      _submitted = true;
    });
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState?.save();

      var result =
          await Provider.of<AuthService>(context, listen: false).loginUser(
        flavor: flavor,
        phonenumber: _phonenumber,
        pincode: _pincode,
      );

      if (result is! Auth) {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarDefault(
            text: result,
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final flavor = Provider.of<Flavor>(context);

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Align(
          alignment: Alignment.center,
          child: SizedBox(
            // width: Responsive.isDesktop(context) ? size.width * 0.3 : size.width * 0.8,
            width: Responsive.isDesktop(context)
                ? size.width * 0.3
                : size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/nars-224.png',
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  children: [
                    Text(
                      flavor.name + ' Login',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding * 2,
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      _buildPhonenumberField(),
                      const SizedBox(height: defaultPadding),
                      _buildPINCodeField(flavor),
                      const SizedBox(height: defaultPadding),
                      SizedBox(
                        width: size.width * 0.8,
                        child: TextButton(
                          onPressed: () async {
                            submit(flavor);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(defaultBorderRadius),
                              ),
                            ),
                            backgroundColor: kPrimaryColor,
                          ),
                          child: isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    SizedBox(width: defaultPadding * .5),
                                    Text(
                                      'LOADING..',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                )
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: defaultPadding),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: defaultPadding),
                const Text(
                  'Forgot your password?',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future _buildShowErrorDialog(BuildContext context, _message) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Error Message'),
  //         content: Text(_message),
  //         actions: <Widget>[
  //           TextButtonDefault(
  //             text: 'Cancel',
  //             press: () {
  //               Navigator.of(context).pop();
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}
