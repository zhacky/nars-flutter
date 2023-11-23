import 'package:nars/models/demo/hospital_demo.dart';
import 'package:nars/models/specialization/specialization.dart';
import 'package:flutter/material.dart';

class Doctor {
  final int id;
  final String image, name, specialty, title, description, days;
  final double rating, experience, patient;
  final Color bgColor;
  final bool ongoing;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final HospitalDemo hospital;
  final List<SpecializationDemo> specializations;

  Doctor({
    required this.id,
    this.image = 'assets/images/doctors/doctor_5.png',
    required this.name,
    this.specialty = '',
    this.title = '',
    this.description = '',
    this.rating = 0,
    this.experience = 0,
    this.patient = 0,
    this.ongoing = false,
    this.days = '',
    this.openTime = const TimeOfDay(hour: 8, minute: 0),
    this.closeTime = const TimeOfDay(hour: 17, minute: 0),
    // this.bgColor = Colors.white,
    // this.bgColor = const Color(0xFFEFEFF2),
    this.bgColor = const Color(0xFFE8EEF8),
    required this.hospital,
    required this.specializations,
  });

  // factory Doctor.fromJson(dynamic json) {
  //   return Doctor(
  //     name: json['doctor_name'] as String,
  //     image: json['profile_image'] as String,
  //   );
  // }

  // static List<Doctor> doctorsFromSnapshot(List snapshot) {
  //   return snapshot.map((data) {
  //     return Doctor.fromJson(data);
  //   }).toList();
  // }
}

List<Doctor> doctors = [
  Doctor(
    id: 2,
    image: 'assets/images/doctors/doctor_5.png',
    name: 'Mary Aquino',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 4.5,
    experience: 1,
    patient: 800,
    ongoing: true,
    days: 'MWF',
    openTime: const TimeOfDay(hour: 8, minute: 0),
    closeTime: const TimeOfDay(hour: 17, minute: 0),
    hospital: hospitals[0],
    specializations: [
      specializationsDemo[0],
    ],
  ),
  Doctor(
    id: 4,
    image: 'assets/images/doctors/doctor_2.png',
    name: 'Robert Santiago',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 4,
    experience: 9,
    patient: 2700,
    ongoing: false,
    days: 'MWF',
    openTime: const TimeOfDay(hour: 9, minute: 0),
    closeTime: const TimeOfDay(hour: 18, minute: 0),
    hospital: hospitals[1],
    specializations: [
      specializationsDemo[1],
    ],
  ),
  Doctor(
    id: 5,
    image: 'assets/images/doctors/doctor_3.png',
    name: 'Susan Dasig',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 5,
    experience: 6,
    patient: 2400,
    ongoing: false,
    days: 'MWF',
    openTime: const TimeOfDay(hour: 8, minute: 0),
    closeTime: const TimeOfDay(hour: 17, minute: 0),
    hospital: hospitals[0],
    specializations: [
      specializationsDemo[0],
    ],
  ),
  Doctor(
    id: 6,
    image: 'assets/images/doctors/doctor_4.png',
    name: 'David De Luna',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 3.5,
    experience: 5,
    patient: 1900,
    ongoing: false,
    days: 'MWF',
    openTime: const TimeOfDay(hour: 8, minute: 0),
    closeTime: const TimeOfDay(hour: 17, minute: 0),
    hospital: hospitals[2],
    specializations: [
      specializationsDemo[2],
    ],
  ),
  Doctor(
    id: 8,
    image: 'assets/images/doctors/doctor_1.png',
    name: 'Julie Dela Cruz',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 4,
    experience: 2,
    patient: 1080,
    ongoing: false,
    days: 'MWF',
    openTime: const TimeOfDay(hour: 8, minute: 0),
    closeTime: const TimeOfDay(hour: 17, minute: 0),
    hospital: hospitals[3],
    specializations: [
      specializationsDemo[4],
    ],
  ),
];
