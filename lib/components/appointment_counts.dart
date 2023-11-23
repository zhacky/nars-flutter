import 'package:nars/components/dashboard_card.dart';
import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class AppointmentCounts extends StatelessWidget {
  AppointmentCounts({
    Key? key,
    required this.size,
    required this.pending,
    required this.approved,
    required this.completed,
  }) : super(key: key);

  final Size size;
  final int pending;
  final int approved;
  final int completed;
  late int total = pending + approved + completed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: size.width,
          child: Row(
            children: [
              DashboardCard(
                title: 'For Approval',
                value: pending.toString(),
                svgScr: 'assets/icons/inspect.svg',
              ),
              const SizedBox(width: defaultPadding),
              DashboardCard(
                title: 'Upcoming',
                value: approved.toString(),
                svgScr: 'assets/icons/hourglass.svg',
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding),
        SizedBox(
          width: size.width,
          child: Row(
            children: [
              DashboardCard(
                title: 'Completed',
                value: completed.toString(),
                svgScr: 'assets/icons/completed.svg',
              ),
              const SizedBox(width: defaultPadding),
              DashboardCard(
                title: 'Appointments',
                value: total.toString(),
                svgScr: 'assets/icons/appointment.svg',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
