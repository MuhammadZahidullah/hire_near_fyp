import 'package:flutter/material.dart';

class WorkerBanner extends StatelessWidget {
  final VoidCallback onTap;
  final bool isWorker;

  const WorkerBanner({
    super.key,
    required this.onTap,
    this.isWorker = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF5B3FE4).withValues(alpha: 0.1),
            child: Icon(
              isWorker ? Icons.dashboard_outlined : Icons.badge,
              color: const Color(0xFF5B3FE4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWorker ? 'Worker Dashboard' : 'Earn with your skills ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // ← bold title
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isWorker
                      ? 'Switch to worker mode and manage your bookings.'
                      : 'Become a worker and start \n earning by offering your services.',
                  style: const TextStyle(
                    color: Colors.grey, // ← grey subtitle
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B3FE4), // purple
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isWorker ? 'Dashboard' : 'Become a worker',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
