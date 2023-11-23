import 'package:nars/constants.dart';
import 'package:nars/models/address/addressAlls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    Key? key,
    required this.address,
    required this.press,
  }) : super(key: key);

  final AddressAll address;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      horizontalTitleGap: 4,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding),
      title:
          // Text(address.address ?? ''),
          Text(
        // (address.homeNo != null
        //         ? (address.homeNo! + (address.street != null ? ', ' : '\n'))
        //         : '') +
        (address.address != null ? (address.address! + '\n') : '') +
            address.barangayName! +
            ', ' +
            address.townName! +
            ', ' +
            address.provinceName!,
      ),
      trailing: Container(
          width: 25,
          margin: const EdgeInsets.only(right: defaultPadding),
          child: address.isDefault!
              ? SvgPicture.asset(
                  'assets/icons/home2.svg',
                  color: kPrimaryColor,
                )
              : null),
      onTap: press,
    );
  }
}
