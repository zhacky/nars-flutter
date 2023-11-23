import 'package:nars/enumerables/appointment_status.dart';
import 'package:nars/models/appointment/appointment_detail.dart';
import 'package:nars/models/appointment/nurse_appointment_detail.dart';
import 'package:nars/models/demo/doctor_demo.dart';
import 'package:nars/models/document/document.dart';
import 'package:nars/models/patient/profile.dart';

import 'dart:convert';

Appointment appointmentFromJson(String str) =>
    Appointment.fromJson(json.decode(str));

String appointmentsToJson(List<Appointment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String appointmentToJson(Appointment data) => json.encode(data.toJson());

class Appointment {
  Appointment({
    required this.id,
    this.practitionerId,
    this.patientUserId,
    this.practitionerName,
    this.patientId,
    this.patientName,
    required this.bookingType,
    required this.schedule,
    required this.appointmentStatus,
    this.reason,
    this.minutes,
    this.medCertFee,
    this.practitionerFee,
    this.systemFee,
    this.covidStatus,
    this.dateOfTest,
    this.dateApproved,
    this.paymentStatus,
    this.practitionerProfilePicture,
    this.specialization,
    this.practitionerSpecialization,
    this.patientProfilePicture,
    this.patientGender,
    this.patientPhoneNumber,
    this.patientEmail,
    this.patientDateOfBirth,
    this.appointmentDetail,
    this.practitionerPhoneNumber,
    this.nurseAppointmentDetail,
    this.appointmentDocuments,
    this.reasonForRescheduling,
  });

  int id;
  int? practitionerId;
  int? patientUserId;
  String? practitionerName;
  int? patientId;
  String? patientName;
  String bookingType;
  DateTime schedule;
  AppointmentStatus appointmentStatus;
  String? reason;
  int? minutes;
  double? medCertFee;
  double? practitionerFee;
  double? systemFee;
  String? covidStatus;
  DateTime? dateOfTest;
  DateTime? dateApproved;
  String? paymentStatus;
  String? practitionerProfilePicture;
  List<String>? specialization;
  List<String>? practitionerSpecialization;
  String? patientProfilePicture;
  String? patientGender;
  String? patientPhoneNumber;
  String? patientEmail;
  String? practitionerPhoneNumber;
  DateTime? patientDateOfBirth;
  AppointmentDetail? appointmentDetail;
  NurseAppointmentDetail? nurseAppointmentDetail;
  List<Document>? appointmentDocuments;
  String? reasonForRescheduling;
  late double total =
      (practitionerFee ?? 0) + (systemFee ?? 0) + (medCertFee ?? 0);

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        patientId: json["patientId"],
        patientName: json["patientName"],
        practitionerId: json["practitionerId"],
        patientUserId: json["patientUserId"],
        practitionerName: json["practitionerName"],
        bookingType: json["bookingType"],
        schedule: DateTime.parse(json["schedule"]),
        appointmentStatus:
            appointmentStatusValues.map[json["appointmentStatus"]]!,
        reason: json["reason"],
        minutes: json["minutes"],
        medCertFee: json["medCertFee"],
        practitionerFee: json["practitionerFee"],
        systemFee: json["systemFee"],
        covidStatus: json["covidStatus"],
        dateOfTest: json["dateOfTest"] == null
            ? null
            : DateTime.parse(json["dateOfTest"]),
        dateApproved: json["dateApproved"] == null
            ? null
            : DateTime.parse(json["dateApproved"]),
        paymentStatus: json["paymentStatus"],
        specialization: json["specialization"] == null
            ? null
            : List<String>.from(json["specialization"].map((x) => x)),
        practitionerSpecialization: json["practitionerSpecialization"] == null
            ? null
            : List<String>.from(
                json["practitionerSpecialization"].map((x) => x)),
        practitionerProfilePicture: json["practitionerProfilePicture"] ??
            'https://acrehealth.s3.ap-southeast-1.amazonaws.com/default_profile.png',
        patientProfilePicture: json["patientProfilePicture"] ??
            'https://acrehealth.s3.ap-southeast-1.amazonaws.com/default_profile.png',
        patientGender: json["patientGender"],
        patientPhoneNumber: json["patientPhoneNumber"],
        practitionerPhoneNumber: json["practitionerPhoneNumber"],
        patientEmail: json["patientEmail"],
        patientDateOfBirth: json["patientDateOfBirth"] == null
            ? null
            : DateTime.parse(json["patientDateOfBirth"]),
        appointmentDetail: json["appointmentDetail"] == null
            ? null
            : AppointmentDetail.fromJson(json["appointmentDetail"]),
        nurseAppointmentDetail: json["nurseAppointmentDetail"] == null
            ? null
            : NurseAppointmentDetail.fromJson(json["nurseAppointmentDetail"]),
        appointmentDocuments: json["appointmentDocuments"] == null
            ? null
            : List<Document>.from(
                json["appointmentDocuments"].map((x) => Document.fromJson(x))),
        reasonForRescheduling: json["reasonForRescheduling"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patientId": patientId,
        "patientName": patientName,
        "practitionerId": practitionerId,
        "patientUserId": patientUserId,
        "practitionerName": practitionerName,
        "bookingType": bookingType,
        "schedule": schedule.toIso8601String(),
        "appointmentStatus":
            appointmentStatusValues.reverse![appointmentStatus],
        "reason": reason,
        "minutes": minutes,
        "medCertFee": medCertFee,
        "practitionerFee": practitionerFee,
        "systemFee": systemFee,
        "covidStatus": covidStatus,
        "dateOfTest": dateOfTest == null ? null : dateOfTest!.toIso8601String(),
        "dateApproved":
            dateApproved == null ? null : dateApproved!.toIso8601String(),
        "paymentStatus": paymentStatus,
        "specialization": specialization == null
            ? null
            : List<dynamic>.from(specialization!.map((x) => x)),
        "practitionerSpecialization": practitionerSpecialization == null
            ? null
            : List<dynamic>.from(practitionerSpecialization!.map((x) => x)),
        "practitionerProfilePicture": practitionerProfilePicture,
        "patientProfilePicture": patientProfilePicture,
        "patientGender": patientGender,
        "patientPhoneNumber": patientPhoneNumber,
        "practitionerPhoneNumber": practitionerPhoneNumber,
        "patientEmail": patientEmail,
        "patientDateOfBirth": patientDateOfBirth == null
            ? null
            : patientDateOfBirth!.toIso8601String(),
        "appointmentDetail":
            appointmentDetail == null ? null : appointmentDetail!.toJson(),
        "nurseAppointmentDetail": nurseAppointmentDetail == null
            ? null
            : nurseAppointmentDetail!.toJson(),
        "appointmentDocuments": appointmentDocuments == null
            ? null
            : List<dynamic>.from(appointmentDocuments!.map((x) => x.toJson())),
        "reasonForRescheduling": reasonForRescheduling,
      };
}

class AppointmentDemo {
  AppointmentDemo({
    required this.doctor,
    required this.profile,
    required this.bodyTemp,
    required this.illness,
    required this.symptoms,
    required this.medHistory,
    required this.reason,
    required this.type,
    required this.vitalSign,
    required this.chiefComplaint,
    required this.subjective,
    required this.objecive,
    required this.assessment,
    required this.plan,
    required this.status,
    required this.medCert,
    required this.consultationFee,
    required this.systemFee,
    required this.medCertFee,
    required this.dateTime,
    this.remark,
    this.reschedReason,
  });

  final Doctor doctor;
  final Profile profile;
  final String bodyTemp,
      illness,
      symptoms,
      medHistory,
      reason,
      type,
      vitalSign,
      chiefComplaint,
      subjective,
      objecive,
      assessment,
      plan;
  final String? remark, reschedReason;
  final AppointmentStatusDemo status;
  final bool medCert;
  final double consultationFee, systemFee, medCertFee;
  final DateTime dateTime;
  late double total = consultationFee + systemFee + medCertFee;
}

List<AppointmentDemo> appointments = [
  AppointmentDemo(
    doctor: doctors[4],
    profile: profiles[0],
    bodyTemp: '39 degree',
    illness: 'Fever',
    symptoms: 'Headache',
    medHistory: 'None',
    reason:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    type: 'Online Consultation',
    vitalSign: 'BP: 120/80\nTemp: 39 Degree',
    chiefComplaint:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    subjective: 'In hac habitasse platea dictumst. Maecenas nec laoreet turpis',
    objecive:
        'Pellentesque eget tellus mollis, ultricies ex eu, laoreet nisi. In sit amet arcu ipsum',
    assessment: 'Etiam lacinia feugiat sem ac euismod. Aenean nisi metus',
    plan:
        'Integer a enim aliquet, egestas risus vel, pretium libero. Praesent vel tortor in tortor molestie auctor',
    status: AppointmentStatusDemo.Completed,
    medCert: true,
    consultationFee: 1000,
    systemFee: 20,
    medCertFee: 400,
    dateTime: DateTime(2022, 3, 19, 14, 00),
    remark: 'I hereby allow her to take a day off for 1 week',
  ),
  AppointmentDemo(
    doctor: doctors[3],
    profile: profiles[1],
    bodyTemp: '39 degree',
    illness: 'Fever',
    symptoms: 'Headache',
    medHistory: 'None',
    reason:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    type: 'Online Consultation',
    vitalSign: 'BP: 120/80\nTemp: 39 Degree',
    chiefComplaint:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    subjective: 'In hac habitasse platea dictumst. Maecenas nec laoreet turpis',
    objecive:
        'Pellentesque eget tellus mollis, ultricies ex eu, laoreet nisi. In sit amet arcu ipsum',
    assessment: 'Etiam lacinia feugiat sem ac euismod. Aenean nisi metus',
    plan:
        'Integer a enim aliquet, egestas risus vel, pretium libero. Praesent vel tortor in tortor molestie auctor',
    status: AppointmentStatusDemo.Completed,
    medCert: true,
    consultationFee: 1000,
    systemFee: 20,
    medCertFee: 400,
    dateTime: DateTime(2022, 3, 20, 8, 00),
    remark: 'I hereby allow her to take a day off for 1 week',
  ),
  AppointmentDemo(
    doctor: doctors[2],
    profile: profiles[0],
    bodyTemp: '39 degree',
    illness: 'Fever',
    symptoms: 'Headache',
    medHistory: 'None',
    reason:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    type: 'Online Consultation',
    vitalSign: 'BP: 120/80\nTemp: 39 Degree',
    chiefComplaint:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    subjective: 'In hac habitasse platea dictumst. Maecenas nec laoreet turpis',
    objecive:
        'Pellentesque eget tellus mollis, ultricies ex eu, laoreet nisi. In sit amet arcu ipsum',
    assessment: 'Etiam lacinia feugiat sem ac euismod. Aenean nisi metus',
    plan:
        'Integer a enim aliquet, egestas risus vel, pretium libero. Praesent vel tortor in tortor molestie auctor',
    status: AppointmentStatusDemo.Completed,
    medCert: true,
    consultationFee: 1000,
    systemFee: 20,
    medCertFee: 400,
    dateTime: DateTime(2022, 3, 21, 11, 00),
    remark: 'I hereby allow her to take a day off for 1 week',
  ),
  AppointmentDemo(
    doctor: doctors[1],
    profile: profiles[1],
    bodyTemp: '39 degree',
    illness: 'Fever',
    symptoms: 'Headache',
    medHistory: 'None',
    reason:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    type: 'Online Consultation',
    vitalSign: 'BP: 120/80\nTemp: 39 Degree',
    chiefComplaint:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    subjective: 'In hac habitasse platea dictumst. Maecenas nec laoreet turpis',
    objecive:
        'Pellentesque eget tellus mollis, ultricies ex eu, laoreet nisi. In sit amet arcu ipsum',
    assessment: 'Etiam lacinia feugiat sem ac euismod. Aenean nisi metus',
    plan:
        'Integer a enim aliquet, egestas risus vel, pretium libero. Praesent vel tortor in tortor molestie auctor',
    status: AppointmentStatusDemo.Accepted,
    medCert: true,
    consultationFee: 1000,
    systemFee: 20,
    medCertFee: 400,
    dateTime: DateTime(2022, 3, 22, 11, 00),
    remark: 'I hereby allow her to take a day off for 1 week',
  ),
  AppointmentDemo(
    doctor: doctors[0],
    profile: profiles[0],
    bodyTemp: '39 degree',
    illness: 'Fever',
    symptoms: 'Headache',
    medHistory: 'None',
    reason:
        'Lorems ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    type: 'Online Consultation',
    vitalSign: 'BP: 120/80\nTemp: 39 Degree',
    chiefComplaint:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    subjective: 'In hac habitasse platea dictumst. Maecenas nec laoreet turpis',
    objecive:
        'Pellentesque eget tellus mollis, ultricies ex eu, laoreet nisi. In sit amet arcu ipsum',
    assessment: 'Etiam lacinia feugiat sem ac euismod. Aenean nisi metus',
    plan:
        'Integer a enim aliquet, egestas risus vel, pretium libero. Praesent vel tortor in tortor molestie auctor',
    status: AppointmentStatusDemo.WaitingForApproval,
    medCert: true,
    consultationFee: 1000,
    systemFee: 20,
    medCertFee: 400,
    dateTime: DateTime(2022, 3, 23, 11, 00),
    remark: 'I hereby allow her to take a day off for 1 week',
  ),
  AppointmentDemo(
    doctor: doctors[1],
    profile: profiles[1],
    bodyTemp: '39 degree',
    illness: 'Fever',
    symptoms: 'Headache',
    medHistory: 'None',
    reason:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    type: 'Online Consultation',
    vitalSign: 'BP: 120/80\nTemp: 39 Degree',
    chiefComplaint:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    subjective: 'In hac habitasse platea dictumst. Maecenas nec laoreet turpis',
    objecive:
        'Pellentesque eget tellus mollis, ultricies ex eu, laoreet nisi. In sit amet arcu ipsum',
    assessment: 'Etiam lacinia feugiat sem ac euismod. Aenean nisi metus',
    plan:
        'Integer a enim aliquet, egestas risus vel, pretium libero. Praesent vel tortor in tortor molestie auctor',
    status: AppointmentStatusDemo.WaitingForApproval,
    medCert: true,
    consultationFee: 1000,
    systemFee: 20,
    medCertFee: 400,
    dateTime: DateTime(2022, 3, 24, 13, 00),
    remark: 'I hereby allow her to take a day off for 1 week',
  ),
  AppointmentDemo(
    doctor: doctors[2],
    profile: profiles[0],
    bodyTemp: '39 degree',
    illness: 'Fever',
    symptoms: 'Headache',
    medHistory: 'None',
    reason:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    type: 'Online Consultation',
    vitalSign: 'BP: 120/80\nTemp: 39 Degree',
    chiefComplaint:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean mi sapien, eleifend ut purus ut',
    subjective: 'In hac habitasse platea dictumst. Maecenas nec laoreet turpis',
    objecive:
        'Pellentesque eget tellus mollis, ultricies ex eu, laoreet nisi. In sit amet arcu ipsum',
    assessment: 'Etiam lacinia feugiat sem ac euismod. Aenean nisi metus',
    plan:
        'Integer a enim aliquet, egestas risus vel, pretium libero. Praesent vel tortor in tortor molestie auctor',
    status: AppointmentStatusDemo.ReschedRequested,
    medCert: true,
    consultationFee: 1000,
    systemFee: 20,
    medCertFee: 400,
    dateTime: DateTime(2022, 3, 25, 9, 00),
    remark: 'I hereby allow her to take a day off for 1 week',
    reschedReason: 'Emergency',
  ),
];
