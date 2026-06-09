import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/custom_text_feild.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/image_upload_box.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/intro_card.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/section_title.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/service_dropdown.dart';
import 'package:hire_near_fyp/feature/become_worker/widgets/submit_button.dart';

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

  String? _selectedService;
  String? _selectedCity;

  final List<String> _services = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'Mechanic',
    'Cleaner',
    'Driver',
    'Mason',
  ];

  final List<String> _cities = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Peshawar',
    'Quetta',
    'Multan',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
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

              // Location
              SectionTitle(title: 'Location'),
              ServiceDropdown(
                hint: 'Your City',
                icon: Icons.location_on_outlined,
                items: _cities,
                value: _selectedCity,
                onChanged: (val) => setState(() => _selectedCity = val),
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
              SubmitButton(label: 'Submit & Become a Worker', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
