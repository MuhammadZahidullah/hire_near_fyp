import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/rounded_button.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/auth/screens/register_screen.dart';
import 'package:hire_near_fyp/feature/favorites/providers/favorites_provider.dart';
import 'package:hire_near_fyp/feature/home/screens/main_screen.dart';
import 'package:hire_near_fyp/feature/worker/screens/worker_dashboard.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/providers/profile_providers.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose

    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/login.png', fit: BoxFit.cover),

            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black45,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.90),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // 👈 rounds the corners
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        hintText: 'Enter Email',
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.black45,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.90),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // 👈 rounds the corners
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),
                  SizedBox(height: 13),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: // ✅ New
                        RoundedButton(
                          title: authProvider.isLoading
                              ? 'Loading...'
                              : 'LogIn',
                          onTap: authProvider.isLoading
                              ? () {}
                              : () async {
                                  await context.read<AuthProvider>().login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );

                                  await context
                                      .read<ProfileProvider>()
                                      .loadProfile();

                                  // ✅ New — role based navigation
                                  if (context.read<AuthProvider>().isLoggedIn) {
                                    final user = context
                                        .read<AuthProvider>()
                                        .currentUser;

                                    if (user?.activeRole == 'worker' ||
                                        user?.isWorker == true) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const WorkerDashboard(),
                                        ),
                                      );
                                    } else {
                                      // Load favorites for this customer.
                                      if (user?.id != null) {
                                        // ignore: use_build_context_synchronously
                                        await context
                                            .read<FavoritesProvider>()
                                            .loadForUser(user!.id);
                                      }
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainScreen(),
                                        ),
                                      );
                                    }
                                  }
                                },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text('Sign Up'),
                      ),
                    ],
                  ),

                  // ← Add here below Row
                  SizedBox(height: 8),

                  // Error Message
                  if (authProvider.errorMessage != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        authProvider.errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  // Loading
                  if (authProvider.isLoading)
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6C3CE1),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
