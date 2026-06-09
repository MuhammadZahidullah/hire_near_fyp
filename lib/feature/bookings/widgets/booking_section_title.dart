import 'package:flutter/material.dart';

class BookingSectionTitle extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const BookingSectionTitle({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        '$title ($count)',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
