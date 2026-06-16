import 'package:flutter/material.dart';

class BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  const BookingDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true, // default true
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFDCFCE7), // light green
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Color(0xFF16A34A), // green
                  size: 18,
                ),
              ),

              SizedBox(width: 16),

              // Label
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),

              Spacer(),

              // Value
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Divider
        if (showDivider) Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}
