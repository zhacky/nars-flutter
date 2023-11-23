import 'package:nars/helpers/helpers.dart';

enum BookingType {
  Online,
  Physical,
}

final bookingTypeValues = EnumValues(
  {
    'Online': BookingType.Online,
    'Physical': BookingType.Physical,
  },
);
