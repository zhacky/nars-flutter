import 'package:flutter/material.dart';

class Nurse {
  final String image, name, specialty, title, description;
  final double rating, experience, patient;
  final Color bgColor;
  final bool ongoing;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;

  Nurse({
    this.image = 'assets/images/nurses/nurse_1.png',
    required this.name,
    this.specialty = '',
    this.title = '',
    this.description = '',
    this.rating = 0,
    this.experience = 0,
    this.patient = 0,
    this.ongoing = false,
    this.openTime = const TimeOfDay(hour: 8, minute: 0),
    this.closeTime = const TimeOfDay(hour: 17, minute: 0),
    // this.bgColor = Colors.white,
    // this.bgColor = const Color(0xFFEFEFF2),
    this.bgColor = const Color(0xFFE8EEF8),
  });

  factory Nurse.fromJson(dynamic json) {
    return Nurse(
      name: json['doctor_name'] as String,
      image: json['profile_image'] as String,
    );
  }

  static List<Nurse> doctorsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Nurse.fromJson(data);
    }).toList();
  }
}

List<Nurse> nurses = [
  Nurse(
    image: 'assets/images/nurses/nurse_3.png',
    name: 'Clara Barton',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 4.5,
    experience: 1,
    patient: 800,
    ongoing: true,
    openTime: const TimeOfDay(hour: 8, minute: 0),
    closeTime: const TimeOfDay(hour: 17, minute: 0),
  ),
  Nurse(
    image: 'assets/images/nurses/nurse_4.png',
    name: 'Mary Taylor',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 4,
    experience: 9,
    patient: 2700,
    ongoing: false,
    openTime: const TimeOfDay(hour: 9, minute: 0),
    closeTime: const TimeOfDay(hour: 18, minute: 0),
  ),
  Nurse(
    image: 'assets/images/nurses/nurse_5.png',
    name: 'Margaret Cavell',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 5,
    experience: 6,
    patient: 2400,
    ongoing: false,
    openTime: const TimeOfDay(hour: 8, minute: 0),
    closeTime: const TimeOfDay(hour: 17, minute: 0),
  ),
  Nurse(
    image: 'assets/images/nurses/nurse_1.png',
    name: 'Elizabeth Henderson',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 3.5,
    experience: 5,
    patient: 1900,
    ongoing: false,
    openTime: const TimeOfDay(hour: 8, minute: 0),
    closeTime: const TimeOfDay(hour: 17, minute: 0),
  ),
  Nurse(
    image: 'assets/images/nurses/nurse_2.png',
    name: 'Isabella Johnson',
    specialty: 'Medicine Specialist',
    title: 'Good Health Clinic, MBBS, FCPS',
    description:
        'Clinical immunologists are doctors who specialise in diagnosing and treating patients with inherited or acquired failures of the immune systems that lead to infections and autoimmune complications (immunodeficiency disorders) and autoimmune diseases and vasculitis where the body harms itself.',
    rating: 4,
    experience: 2,
    patient: 1080,
    ongoing: false,
    openTime: const TimeOfDay(hour: 8, minute: 0),
    closeTime: const TimeOfDay(hour: 17, minute: 0),
  ),
];
