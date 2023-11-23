import 'package:nars/helpers/helpers.dart';

enum Status {
  Active,
  Inactive,
  WaitingForApproval,
  Declined,
}

final statusValues = EnumValues(
  {
    "Active": Status.Active,
    "Inactive": Status.Inactive,
    "WaitingForApproval": Status.WaitingForApproval,
    "Declined": Status.Declined,
  },
);
