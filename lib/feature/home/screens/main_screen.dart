import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/home/screens/home_screen.dart';
import 'package:hire_near_fyp/features/home/widgets/buttom_nav_bar.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/profile_screen.dart';
//import 'package:hire_near_fyp/features/home/screens/home_screen.dart';
//import 'package:hire_near_fyp/features/become_worker/screens/become_worker_screen.dart';
//import 'package:hire_near_fyp/feature/home/screens/home_screen.dart';
//import 'package:hire_near_fyp/feature/auth/screens/profile_screen.dart';

//import 'package:hire_near_fyp/features/home/widgets/buttom_nav_bar.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),

    Container(),
    Container(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: ButtomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
