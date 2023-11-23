import 'package:nars/helpers/helpers.dart';

enum AppointmentStatus {
  Pending,
  WaitingForApproval,
  Approved,
  Ongoing,
  Completed,
  Cancelled,
  Disapproved,
  Refunded,
  ReschedByPractitioner,
  ReschedByPatient,
  Unpaid,
}

final appointmentStatusValues = EnumValues(
  {
    'Pending': AppointmentStatus.Pending,
    'WaitingForApproval': AppointmentStatus.WaitingForApproval,
    'Approved': AppointmentStatus.Approved,
    'Ongoing': AppointmentStatus.Ongoing,
    'Completed': AppointmentStatus.Completed,
    'Cancelled': AppointmentStatus.Cancelled,
    'Disapproved': AppointmentStatus.Disapproved,
    'Refunded': AppointmentStatus.Refunded,
    'ReschedByPractitioner': AppointmentStatus.ReschedByPractitioner,
    'ReschedByPatient': AppointmentStatus.ReschedByPatient,
    'Unpaid': AppointmentStatus.Unpaid,
  },
);

enum AppointmentStatusDemo {
  Completed,
  Accepted,
  WaitingForApproval,
  ReschedRequested,
}
