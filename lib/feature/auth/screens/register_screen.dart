import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/rounded_button.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/home/screens/main_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
            // Background Image
            Image.asset('assets/images/signup.png', fit: BoxFit.cover),

            // Content
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50),

                  // Name Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: nameController,
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.black45,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.90),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        hintText: 'Enter Name',
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Email Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                          borderRadius: BorderRadius.circular(16),
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

                  // Password Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.black45,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.90),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
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

                  SizedBox(height: 20),

                  // SignUp Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: RoundedButton(
                      title: authProvider.isLoading ? 'Loading...' : 'SignUp',
                      onTap: authProvider.isLoading
                          ? () {}
                          : () async {
                              await context.read<AuthProvider>().register(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );

                              if (context.read<AuthProvider>().isLoggedIn) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ),
                                );
                              }
                            },
                    ),
                  ),

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

                  // Loading Indicator
                  if (authProvider.isLoading)
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6C3CE1),
                        ),
                      ),
                    ),

                  SizedBox(height: 20),

                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
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
