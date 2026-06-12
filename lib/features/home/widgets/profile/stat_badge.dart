import 'package:flutter/material.dart';

class StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatBadge({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red, // ← bright red to confirm change
      padding: EdgeInsets.all(8),
      child: Text(value, style: TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}
