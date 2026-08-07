import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String workerName;

  const DashboardHeader({super.key, required this.workerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5B3FE4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back 👋',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 6),

          Text(
            workerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Manage your bookings and grow your business.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
