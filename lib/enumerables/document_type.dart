import 'package:nars/helpers/helpers.dart';

enum DocumentType {
  Diploma,
  LicenseID,
  MedicalCertificate,
  Other,
  PRCID,
  SelfieWithPRCID,
  AppointmentDocument,
}

final documentTypeValues = EnumValuesByInt(
  {
    0: DocumentType.Diploma,
    1: DocumentType.LicenseID,
    2: DocumentType.MedicalCertificate,
    3: DocumentType.Other,
    4: DocumentType.PRCID,
    5: DocumentType.SelfieWithPRCID,
    6: DocumentType.AppointmentDocument,
  },
);
