import 'package:nars/helpers/helpers.dart';

enum NurseServices {
  GeneralMonitoring,
  AdministrationOfOralMedication,
  AdministrationOfIVMedication,
  FeedingOral,
  FeedingNGT,
}

final nurseServicesValues = EnumValuesByInt(
  {
    0: NurseServices.GeneralMonitoring,
    1: NurseServices.AdministrationOfOralMedication,
    2: NurseServices.AdministrationOfIVMedication,
    3: NurseServices.FeedingOral,
    4: NurseServices.FeedingNGT,
  },
);

String getNurseServicesName(NurseServices data) {
  switch (data) {
    case NurseServices.GeneralMonitoring:
      return 'General Monitoring';
    case NurseServices.AdministrationOfOralMedication:
      return 'Administration of Oral Medications';
    case NurseServices.AdministrationOfIVMedication:
      return 'Administration of IV Medications';
    case NurseServices.FeedingOral:
      return 'Feeding (Oral)';
    case NurseServices.FeedingNGT:
      return 'Feeding (NGT)';
    default:
      return data.name;
  }
}
