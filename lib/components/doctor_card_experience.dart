import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorCardExperience extends StatelessWidget {
  const DoctorCardExperience({
    Key? key,
    required this.experience,
  }) : super(key: key);

  final double experience;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Experience',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 10,
          ),
        ),
        Text(
          NumberFormat("#,###.##").format(experience) +
              ' Year' +
              (experience > 1 ? 's' : ''),
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
