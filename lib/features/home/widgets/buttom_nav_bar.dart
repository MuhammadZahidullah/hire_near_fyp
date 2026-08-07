import 'package:flutter/material.dart';

class ButtomNavBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;
  const ButtomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // int currentIndex = 0;
    // final List<Widget> screens = [
    //   HomeScreen(),
    //   //BookingScreen(),
    //   //MessagesScreen(),
    //   ProfileScreen(),
    // ];
    return BottomNavigationBar(
      //currentIndex=currentIndex;
      onTap: onTap,
      currentIndex: currentIndex,
      selectedItemColor: Color(0xFF6C3CE1),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,

      items: [
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
        BottomNavigationBarItem(
          label: 'Booking',
          icon: Icon(Icons.calendar_month_outlined),
        ),
        BottomNavigationBarItem(label: 'Messages', icon: Icon(Icons.chat)),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.person_2_outlined),
        ),
      ],
    );
  }
}
