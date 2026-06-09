import 'package:flutter/material.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/menu_item_tile.dart';

class MenuSection extends StatelessWidget {
  final String title;
  final List<MenuItemTile> items;

  const MenuSection({super.key, required this.items, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),

        // White card with all tiles
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items, // ← just put all tiles here
          ),
        ),
      ],
    );
  }
}
