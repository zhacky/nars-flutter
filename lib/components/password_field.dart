import 'package:nars/components/card_container.dart';
import 'package:nars/constants.dart';
import 'package:nars/screens/pincode/pincode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    Key? key,
    required this.onChanged,
    required this.title,
    this.icon = const Text(''),
    this.suffixIcon = const Text(''),
  }) : super(key: key);

  final String title;
  final ValueChanged<String> onChanged;
  final Widget icon;
  final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PincodeScreen(
              callback: () {},
            ),
          ),
        );
      },
      child: CardContainer(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: 16),
        child: Row(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset('assets/icons/lock5.svg'),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                'assets/icons/eye4.svg',
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
