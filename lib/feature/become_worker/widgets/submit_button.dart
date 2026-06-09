import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SubmitButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF6C3CE1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock_outline, color: Colors.grey, size: 14),
            SizedBox(width: 4),
            Text(
              'Your information is safe and secure',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
