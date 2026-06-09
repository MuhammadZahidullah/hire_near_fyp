import 'package:flutter/material.dart';

class IntroCard extends StatelessWidget {
  const IntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> benefits = [
      'Get more job opportunities',
      'Earn on your own terms',
      'Grow your trusted profile',
    ];

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why become a worker?',
                  style: TextStyle(
                    color: Color(0xFF6C3CE1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ...benefits.map((benefit) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF6C3CE1),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          benefit,
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Icon(Icons.engineering, size: 80, color: Color(0xFF6C3CE1)),
        ],
      ),
    );
  }
}
