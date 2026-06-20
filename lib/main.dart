import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/theme/app_theme.dart';
import 'package:hire_near_fyp/feature/bookings/providers/booking_provider.dart';
import 'package:hire_near_fyp/feature/home/screens/home_screen.dart';
import 'package:hire_near_fyp/feature/splash/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,

        home: SplashScreen(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        title: Text('HireNear', style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
      ),
      body: Text('Developer Muhammad Zahidullah'),
    );
  }
}
