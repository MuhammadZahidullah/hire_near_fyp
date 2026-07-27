import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/rounded_button.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/home/screens/main_screen.dart';
import 'package:hire_near_fyp/feature/worker/screens/worker_dashboard.dart';
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
  final phoneController = TextEditingController();
  String _selectedRole = 'user';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
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

                  SizedBox(height: 16),

                  // Email Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
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

                  SizedBox(height: 16),

                  // Phone Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone_outlined,
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
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

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

                  // Role Selection
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I want to:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            // User option
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedRole = 'user'),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'user'
                                        ? Color(0xFF6C3CE1)
                                        : Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white54),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Find Service',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 12),

                            // Worker option
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedRole = 'worker'),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'worker'
                                        ? Color(0xFF6C3CE1)
                                        : Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white54),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.handyman,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Offer Service',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                                phoneController.text.trim(),
                                _selectedRole,
                              );

                              if (context.read<AuthProvider>().isLoggedIn) {
                                final user = context
                                    .read<AuthProvider>()
                                    .currentUser;

                                if (user?.activeRole == 'worker') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkerDashboard(),
                                    ),
                                  );
                                } else {
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

                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
