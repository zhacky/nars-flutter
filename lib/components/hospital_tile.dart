import 'package:nars/constants.dart';
import 'package:nars/models/practitioner/practitioner_hospital.dart';
import 'package:flutter/material.dart';

class HospitalTile extends StatelessWidget {
  const HospitalTile({
    Key? key,
    required this.hospital,
    required this.press,
  }) : super(key: key);

  final PractitionerHospital hospital;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    var hospitalAddress = hospital.hospitalAddress;
    var hospitalSchedule = hospital.hospitalSchedule;
    return ListTile(
      tileColor: Colors.white,
      horizontalTitleGap: 4,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding),
      title: Text(hospital.hospitalName!),
      subtitle:
          // Text(address.address ?? ''),
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // (address.homeNo != null
            //         ? (address.homeNo! + (address.street != null ? ', ' : '\n'))
            //         : '') +
            (hospitalAddress?.address != null
                    ? (hospitalAddress!.address + '\n')
                    : '') +
                hospitalAddress!.barangayName! +
                ', ' +
                hospitalAddress.townName! +
                ', ' +
                hospitalAddress.provinceName!,
          ),
          const SizedBox(height: defaultPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              hospitalSchedule.length,
              (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospitalSchedule[index].day!,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      hospitalSchedule[index].hospitalScheduleTimeSpans.length,
                      (index2) => Text(
                        hospitalSchedule[index]
                                .hospitalScheduleTimeSpans[index2]
                                .start!
                                .format(context) +
                            ' - ' +
                            hospitalSchedule[index]
                                .hospitalScheduleTimeSpans[index2]
                                .end!
                                .format(context),
                      ),
                    ),
                  ),
                  if (index != hospitalSchedule.length - 1)
                    const SizedBox(height: defaultPadding),
                ],
              ),
            ),
          ),
        ],
      ),
      // trailing: Container(
      //     width: 25,
      //     margin: const EdgeInsets.only(right: defaultPadding),
      //     child: address.isDefault
      //         ? SvgPicture.asset(
      //             'assets/icons/home2.svg',
      //             color: kPrimaryColor,
      //           )
      //         : null),
      onTap: press,
    );
  }
}
