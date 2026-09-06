
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/auth/screens/login_screen.dart';
import 'package:hire_near_fyp/feature/favorites/providers/favorites_provider.dart';
import 'package:hire_near_fyp/feature/home/screens/main_screen.dart';
import 'package:hire_near_fyp/feature/worker/screens/worker_dashboard.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/providers/profile_providers.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();

      await authProvider.checkAuthState();

      if (!mounted) return;

        if (authProvider.isLoggedIn) {
        final user = authProvider.currentUser;
        final isWorker = user?.activeRole == 'worker' || user?.isWorker == true;

        if (isWorker) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WorkerDashboard()),
          );
        } else {
          // Load this customer's favorites before showing the home screen.
          if (user?.id != null) {
            // ignore: use_build_context_synchronously
            await context.read<FavoritesProvider>().loadForUser(user!.id);
          }
          // ignore: use_build_context_synchronously
          context.read<ProfileProvider>().loadProfile();
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ← white background
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Image.asset(
            'assets/images/splash_image.png',
            fit: BoxFit.contain, // ← shows full image
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
