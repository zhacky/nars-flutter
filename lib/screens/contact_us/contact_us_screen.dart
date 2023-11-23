import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarDefault(title: 'Contact Us'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              // CardContainer(
              //   width: size.width,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       SvgPicture.asset(
              //         'assets/icons/phone3.svg',
              //         color: kPrimaryColor,
              //         height: 50,
              //       ),
              //       const SizedBox(height: defaultPadding),
              //       Text(
              //         'Phone',
              //         style: Theme.of(context).textTheme.headline6!.copyWith(
              //               fontWeight: FontWeight.w700,
              //             ),
              //       ),
              //       const SizedBox(height: defaultPadding),
              //       Text(
              //         '+63927 436 9457 | +63917 138 9993\n+632 7616 7803',
              //         style: Theme.of(context).textTheme.subtitle1,
              //       ),
              //     ],
              //   ),
              // ),
              Text(
                'How can we help you?',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: defaultPadding),
              CardContainer(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/email.svg',
                      color: kPrimaryColor,
                      height: 50,
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      'Email',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      'care@nars.today',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
