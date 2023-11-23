import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorCardPatient extends StatelessWidget {
  const DoctorCardPatient({
    Key? key,
    required this.amount,
    required this.label,
  }) : super(key: key);

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 10,
          ),
        ),
        Text(
          NumberFormat("#,###.##").format(amount / 1000) + 'K',
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
