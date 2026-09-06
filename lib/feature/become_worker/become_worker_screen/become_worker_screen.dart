import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/custom_text_feild.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/image_upload_box.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/intro_card.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/section_title.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/service_dropdown.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/submit_button.dart';
import 'package:provider/provider.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/providers/profile_providers.dart';
import 'package:hire_near_fyp/feature/worker/providers/worker_provider.dart';
import 'package:hire_near_fyp/feature/review/providers/review_provider.dart';

class BecomeWorkerScreen extends StatefulWidget {
  const BecomeWorkerScreen({super.key});

  @override
  State<BecomeWorkerScreen> createState() => _BecomeWorkerScreenState();
}

class _BecomeWorkerScreenState extends State<BecomeWorkerScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _experienceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedService;

  final List<String> _services = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'Mechanic',
    'Cleaner',
    'Driver',
    'Mason',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final location = authProvider.currentUser?.location;
      if (location != null && location != 'Not set') {
        _locationController.text = location;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Become a Worker',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Join our community and start earning',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Icon(Icons.headset_mic),
                ],
              ),

              SizedBox(height: 16),

              // Intro Card
              IntroCard(),

              // Basic Information
              SectionTitle(title: 'Basic Information'),
              CustomTextField(
                hintText: 'Full Name',
                icon: Icons.person_outline,
                controller: _nameController,
              ),
              CustomTextField(
                hintText: 'Phone Number',
                icon: Icons.phone_outlined,
                controller: _phoneController,
              ),
              CustomTextField(
                hintText: 'Email Address',
                icon: Icons.email_outlined,
                controller: _emailController,
              ),

              // Service Information
              SectionTitle(title: 'Service Information'),
              Text(
                'Select Your Skill / Service',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 8),
              ServiceDropdown(
                hint: 'Choose a service',
                icon: Icons.grid_view,
                items: _services,
                value: _selectedService,
                onChanged: (val) => setState(() => _selectedService = val),
              ),
              CustomTextField(
                hintText: 'e.g. 3 years',
                icon: Icons.calendar_today_outlined,
                controller: _experienceController,
              ),
              CustomTextField(
                hintText: 'Describe your skills and experience...',
                icon: Icons.description_outlined,
                controller: _descriptionController,
                maxLines: 4,
              ),
              CustomTextField(
                hintText: 'Price',
                icon: Icons.attach_money_outlined,
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),

              // Location
              SectionTitle(title: 'Location'),
              CustomTextField(
                hintText: 'Your City / Location',
                icon: Icons.location_on_outlined,
                controller: _locationController,
              ),
              CustomTextField(
                hintText: 'Full Address (Optional)',
                icon: Icons.map_outlined,
                controller: _addressController,
              ),

              // Image Upload
              Text(
                'Upload Profile Image (Optional)',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 8),
              ImageUploadBox(onTap: () {}),

              SizedBox(height: 8),

              // Submit Button
              SubmitButton(
                label: 'Submit & Become a Worker',
                onTap: () async {
                  final authProvider = context.read<AuthProvider>();

                  if (authProvider.currentUser == null) return;

                  final skill = _selectedService ?? '';
                  final experience = _experienceController.text.trim();
                  final description = _descriptionController.text.trim();
                  final priceText = _priceController.text.trim();
                  final location = _locationController.text.trim();

                  if (skill.isEmpty ||
                      experience.isEmpty ||
                      description.isEmpty ||
                      priceText.isEmpty ||
                      location.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill in all required fields."),
                      ),
                    );
                    return;
                  }

                  final price = int.tryParse(priceText);
                  if (price == null || price <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid positive price."),
                      ),
                    );
                    return;
                  }

                    try {
                      await authProvider.becomeWorker(
                        skill: skill,
                        experience: experience,
                        price: price,
                        description: description,
                        location: location,
                      );

                      if (!context.mounted) return;

                      // Fix: Refresh ProfileProvider and WorkerProvider after become worker
                      context.read<ProfileProvider>().loadProfile();
                      context.read<WorkerProvider>().fetchWorkers(
                        reviewProvider: context.read<ReviewProvider>(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You are now registered as a worker!"),
                        ),
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString().replaceAll('Exception: ', '')),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
