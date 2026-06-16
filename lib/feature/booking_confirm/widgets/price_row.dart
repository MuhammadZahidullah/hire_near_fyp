import 'package:flutter/material.dart';

class PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool showDivider;

  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: isTotal ? 15 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Colors.black : Colors.black87,
                ),
              ),

              // Value
              Text(
                value,
                style: TextStyle(
                  fontSize: isTotal ? 16 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal
                      ? Color(0xFF16A34A) // green for total
                      : Colors.black87,
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
