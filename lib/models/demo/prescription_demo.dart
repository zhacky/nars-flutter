class PrescriptionDemo {
  final int appointmentId;
  final String name, dosage;
  final String? preparation, duration, quantity;

  PrescriptionDemo({
    required this.appointmentId,
    required this.name,
    required this.dosage,
    this.preparation,
    this.duration,
    this.quantity,
  });
}

List<PrescriptionDemo> prescriptions = [
  PrescriptionDemo(
    appointmentId: 1,
    name: 'Paracetamol',
    dosage: 'Every 4hrs',
    preparation: '400mg',
    duration: '2 weeks',
    quantity: '3 tab',
  ),
  PrescriptionDemo(
    appointmentId: 1,
    name: 'Amoxicillin',
    dosage: '3x a day',
    preparation: '300mg',
    duration: '1 week',
    quantity: '2 tab',
  ),
];
