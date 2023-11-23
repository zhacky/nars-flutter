import 'package:nars/helpers/helpers.dart';

enum PatientContraption {
  None,
  ETT,
  NGT,
  IV,
  Others,
}

final patientContraptionsValues = EnumValuesByInt(
  {
    0: PatientContraption.None,
    1: PatientContraption.ETT,
    2: PatientContraption.NGT,
    3: PatientContraption.IV,
    4: PatientContraption.Others,
  },
);
