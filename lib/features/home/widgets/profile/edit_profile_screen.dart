import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/providers/profile_providers.dart';
import 'package:provider/provider.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/worker/providers/worker_provider.dart';
import 'package:hire_near_fyp/feature/review/providers/review_provider.dart';

/// Single edit-profile screen for both customer and worker accounts.
/// Worker-specific fields (skill, experience, price, description) are shown
/// only when the logged-in user is a worker.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Common controllers
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _locationCtrl;

  // Worker-only controllers
  late final TextEditingController _skillCtrl;
  late final TextEditingController _experienceCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descriptionCtrl;

  bool _isSaving = false;
  bool _isWorker = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileProvider>().user;
    _isWorker = user?.isWorker == true || user?.activeRole == 'worker';

    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _locationCtrl = TextEditingController(text: user?.location ?? '');
    _skillCtrl = TextEditingController(text: user?.skill ?? '');
    _experienceCtrl = TextEditingController(text: user?.experience ?? '');
    _priceCtrl = TextEditingController(
      text: (user?.price != null && user!.price! > 0)
          ? user.price.toString()
          : '',
    );
    _descriptionCtrl = TextEditingController(text: user?.description ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    _skillCtrl.dispose();
    _experienceCtrl.dispose();
    _priceCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final error = await context.read<ProfileProvider>().saveProfile(
          name: _nameCtrl.text,
          phone: _phoneCtrl.text,
          location: _locationCtrl.text,
          skill: _isWorker ? _skillCtrl.text : null,
          experience: _isWorker ? _experienceCtrl.text : null,
          price: _isWorker ? int.tryParse(_priceCtrl.text.trim()) : null,
          description: _isWorker ? _descriptionCtrl.text : null,
        );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error == null) {
      // Fix: Refresh AuthProvider and WorkerProvider after successful profile edit
      context.read<AuthProvider>().checkAuthState();
      if (_isWorker) {
        context.read<WorkerProvider>().fetchWorkers(
          reviewProvider: context.read<ReviewProvider>(),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 14),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6C3CE1)),
          filled: true,
          fillColor: readOnly ? const Color(0xFFF0F0F0) : Colors.white,
          labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6C3CE1), width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6C3CE1),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Read email to display (not editable — Req 8)
    final email = context.read<ProfileProvider>().userEmail;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6C3CE1),
                      ),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _save,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Color(0xFF6C3CE1),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar placeholder ────────────────────────────────────────
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: const Color(0xFF6C3CE1),
                      child: Text(
                        _nameCtrl.text.isNotEmpty
                            ? _nameCtrl.text[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Image upload disabled (Req 9)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'Photo upload coming soon',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // ── Basic Information ─────────────────────────────────────────
              _sectionHeader('Basic Information'),
              _buildField(
                label: 'Full Name',
                controller: _nameCtrl,
                icon: Icons.person_outline,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              // Email — read-only (Req 8)
              _buildField(
                label: 'Email',
                controller: TextEditingController(text: email),
                icon: Icons.email_outlined,
                readOnly: true,
              ),
              _buildField(
                label: 'Phone Number',
                controller: _phoneCtrl,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              _buildField(
                label: 'Location / City',
                controller: _locationCtrl,
                icon: Icons.location_on_outlined,
              ),

              // ── Worker-only fields ────────────────────────────────────────
              if (_isWorker) ...[
                const Divider(height: 28),
                _sectionHeader('Worker Information'),
                _buildField(
                  label: 'Skill / Service',
                  controller: _skillCtrl,
                  icon: Icons.work_outline,
                  hint: 'e.g. Plumber, Electrician',
                  validator: (v) {
                    if (_isWorker && (v == null || v.trim().isEmpty)) {
                      return 'Skill cannot be empty';
                    }
                    return null;
                  },
                ),
                _buildField(
                  label: 'Experience',
                  controller: _experienceCtrl,
                  icon: Icons.calendar_today_outlined,
                  hint: 'e.g. 3 years',
                ),
                _buildField(
                  label: 'Price (PKR per service)',
                  controller: _priceCtrl,
                  icon: Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (!_isWorker) return null;
                    final parsed = int.tryParse(v?.trim() ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Price must be greater than 0';
                    }
                    return null;
                  },
                ),
                _buildField(
                  label: 'Description',
                  controller: _descriptionCtrl,
                  icon: Icons.description_outlined,
                  hint: 'Describe your skills and experience…',
                  maxLines: 3,
                ),
              ],

              const SizedBox(height: 24),

              // ── Save button ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C3CE1),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
