import 'package:flutter/material.dart';

class PostJobBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const PostJobBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                SizedBox(height: 4),
                Text(subtitle),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C3CE1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onTap,
                  child: Text('Post a Job'),
                ),
              ],
            ),
          ),
          Icon(
            // ← add this
            Icons.home_repair_service,
            size: 80,
            color: Color(0xFF6C3CE1),
          ),
        ],
      ),
    );
  }
}
