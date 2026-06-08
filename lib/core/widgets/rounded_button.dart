import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const RoundedButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        child: Container(
          // width: double.infinity,
          width: 140,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Color(0xFF6C63FF), // 👈 modern purple,
          ),
          height: 59,
          padding: EdgeInsets.symmetric(horizontal: 24),

          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
