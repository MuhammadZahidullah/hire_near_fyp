import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String userName;
  final String location;
  final int notificationCount;
  const TopBar({
    super.key,
    required this.location,
    required this.notificationCount,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(radius: 30),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AOA, $userName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 13, color: Color(0xFF6C3CE1)),
                    SizedBox(width: 5),
                    Text(
                      location,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Icon(Icons.notifications_outlined, size: 28, color: Colors.black),
              Positioned(
                right: 0,
                top: 0,

                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    notificationCount.toString(),

                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
