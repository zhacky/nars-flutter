import 'package:nars/helpers/helpers.dart';

enum DocumentStatus {
  Processing,
  Approved,
  Declined,
}

final documentStatusValues = EnumValues(
  {
    "Processing": DocumentStatus.Processing,
    "Approved": DocumentStatus.Approved,
    "Declined": DocumentStatus.Declined,
  },
);
