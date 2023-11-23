import 'package:nars/api/otp_api.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/components/digit_holder.dart';
import 'package:nars/components/digitpad.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    Key? key,
    this.title = 'PIN Code',
    this.subtitle = 'Please enter and remember your safety PIN',
    this.phonenumber,
    required this.callback,
    this.loadOnce = true,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String? phonenumber;
  final Function callback;
  final bool loadOnce;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var selectedIndex = 0;
  String? code = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width =
        Responsive.isDesktop(context) ? size.width * 0.30 : size.width;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 0,
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.15,
              width: size.width,
            ),
            CardContainer(
              height: size.height * 0.85,
              width: size.width,
              padding: null,
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius * 3),
                topRight: Radius.circular(defaultBorderRadius * 3),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Text(
                            widget.subtitle,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          const SizedBox(height: defaultPadding),
                          if (widget.loadOnce)
                            TextButton(
                              onPressed: () async {
                                var sendOtp = await OtpApi.sendOtp(
                                    widget.phonenumber!, true);
                                if (sendOtp.statusCode != 200)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarDefault(
                                      text: sendOtp.body,
                                    ),
                                  );
                              },
                              child: Text("Resend OTP Code"),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      // color: Colors.pink,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DigitHolder(
                            width: width,
                            index: 0,
                            selectedIndex: selectedIndex,
                            code: code!,
                          ),
                          DigitHolder(
                            width: width,
                            index: 1,
                            selectedIndex: selectedIndex,
                            code: code!,
                          ),
                          DigitHolder(
                            width: width,
                            index: 2,
                            selectedIndex: selectedIndex,
                            code: code!,
                          ),
                          DigitHolder(
                            width: width,
                            index: 3,
                            selectedIndex: selectedIndex,
                            code: code!,
                          ),
                          DigitHolder(
                            width: width,
                            index: 4,
                            selectedIndex: selectedIndex,
                            code: code!,
                          ),
                          DigitHolder(
                            width: width,
                            index: 5,
                            selectedIndex: selectedIndex,
                            paddingRight: 0,
                            code: code!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              DigitPad(
                                press: () {
                                  addDigit(1);
                                },
                                value: '1',
                              ),
                              DigitPad(
                                press: () {
                                  addDigit(2);
                                },
                                value: '2',
                              ),
                              DigitPad(
                                press: () {
                                  addDigit(3);
                                },
                                value: '3',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              DigitPad(
                                press: () {
                                  addDigit(4);
                                },
                                value: '4',
                              ),
                              DigitPad(
                                press: () {
                                  addDigit(5);
                                },
                                value: '5',
                              ),
                              DigitPad(
                                press: () {
                                  addDigit(6);
                                },
                                value: '6',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              DigitPad(
                                press: () {
                                  addDigit(7);
                                },
                                value: '7',
                              ),
                              DigitPad(
                                press: () {
                                  addDigit(8);
                                },
                                value: '8',
                              ),
                              DigitPad(
                                press: () {
                                  addDigit(9);
                                },
                                value: '9',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              DigitPad(
                                press: () {
                                  addDigit(0);
                                },
                                value: '0',
                              ),
                              DigitPad(
                                press: () {
                                  backspace();
                                },
                                value: 'Back',
                                icon: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: SvgPicture.asset(
                                    'assets/icons/backspace.svg',
                                    color: const Color(0xFF444444),
                                  ),
                                ),
                                isIcon: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  addDigit(int digit) {
    if (code!.length > 5) {
      return;
    }
    setState(() {
      code = code! + digit.toString();
      selectedIndex = code!.length;
      if (code!.length > 5) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const SignupScreen2(),
        //   ),
        // );

        widget.callback(code);
      }
    });
  }

  backspace() {
    if (code!.isEmpty) {
      return;
    }
    setState(() {
      code = code!.substring(0, code!.length - 1);
      selectedIndex = code!.length;
    });
  }
}
