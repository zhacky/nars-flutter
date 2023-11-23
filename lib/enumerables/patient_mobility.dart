import 'package:nars/helpers/helpers.dart';

enum PatientMobility {
  Walking,
  InAWheelchair,
  Bedridden,
}

final patientMobilitiesValues = EnumValuesByInt(
  {
    0: PatientMobility.Walking,
    1: PatientMobility.InAWheelchair,
    2: PatientMobility.Bedridden,
  },
);

String getPatientMobilitiesName(PatientMobility data) {
  switch (data) {
    case PatientMobility.InAWheelchair:
      return 'In a wheelchair';
    default:
      return data.name;
  }
}
