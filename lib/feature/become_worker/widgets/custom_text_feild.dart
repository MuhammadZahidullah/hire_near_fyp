import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines ?? 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
