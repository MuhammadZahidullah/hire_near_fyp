

import 'package:flutter/material.dart';

class MenuItemTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;
  final Widget? trailing;
  final VoidCallback onTap;
  const MenuItemTile({super.key, required this.icon,
    required this.label,
    this.isDanger = false,   // ← default false, only true for Logout
    this.trailing,           // ← optional, no "required"
    required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
  onTap: onTap,
  leading: Icon(
    icon,
    color: isDanger ? Colors.red : Color(0xFF5B3FE4),  // red or purple
  ),
  title: Text(
    label,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isDanger ? Colors.red : Color(0xFF111827), // red or dark
    ),
  ),
  trailing: trailing ?? Icon(
    Icons.chevron_right,
    color: Colors.grey,        // ← default arrow if no trailing passed
  ),
);
  }
}