import 'package:nars/constants.dart';
import 'package:nars/models/prescription/prescription.dart';
import 'package:flutter/material.dart';

class PrescriptionTile extends StatelessWidget {
  const PrescriptionTile({
    Key? key,
    required this.prescription,
    required this.press,
  }) : super(key: key);

  final Prescription prescription;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      horizontalTitleGap: 4,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: prescription.drugName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              children: [
                if (prescription.preparation != null)
                  TextSpan(
                    text: ' (' + (prescription.preparation ?? '') + ')',
                  ),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding * .5),
          Row(
            children: [
              Text(prescription.dosage),
              const Spacer(),
              Text((prescription.quantity ?? '')),
              if (prescription.quantity != null &&
                  prescription.duration != null)
                const Text(' - '),
              Text((prescription.duration ?? '')),
            ],
          )
        ],
      ),
      onTap: press,
    );
  }
}
