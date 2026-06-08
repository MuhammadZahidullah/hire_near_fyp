import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/rounded_button.dart';
import 'package:hire_near_fyp/feature/auth/screens/register_screen.dart';
import 'package:hire_near_fyp/feature/home/screens/home_screen.dart';
import 'package:hire_near_fyp/feature/home/screens/main_screen.dart';
import 'package:hire_near_fyp/main.dart';

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
                        child: RoundedButton(
                          title: 'LogIn',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
