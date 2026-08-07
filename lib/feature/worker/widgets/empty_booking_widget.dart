import 'package:flutter/material.dart';

class EmptyBookingWidget extends StatelessWidget {
  const EmptyBookingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(Icons.work_off_outlined, size: 70, color: Colors.grey.shade400),

          const SizedBox(height: 18),

          const Text(
            "No Booking Requests",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            "You don't have any booking requests yet.\nNew requests will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, height: 1.5),
          ),
        ],
      ),
    );
  }
}
