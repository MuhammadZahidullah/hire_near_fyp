import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/app_snack_bar.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/booking_detail_section.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/price_detail_section.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/security_banner.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/worker_summary_card.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/bookings/providers/booking_provider.dart';
import 'package:hire_near_fyp/feature/home/screens/main_screen.dart';
import 'package:hire_near_fyp/feature/notifications/providers/notification_provider.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/providers/profile_providers.dart';
import 'package:provider/provider.dart';

// Simple date formatter (avoids adding the intl package as a dependency).
String _formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}

class ConfirmBookingScreen extends StatefulWidget {
  final ConfirmBookingModel booking;

  const ConfirmBookingScreen({super.key, required this.booking});

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _locationController = TextEditingController();
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pre-fill location from user profile when available
      final profileLocation =
          context.read<ProfileProvider>().userLocation.trim();
      if (profileLocation.isNotEmpty && _locationController.text.isEmpty) {
        setState(() {
          _locationController.text = profileLocation;
        });
      }
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  String get _formattedDate =>
      _selectedDate == null ? '' : _formatDate(_selectedDate!);

  String get _formattedTime =>
      _selectedTime == null ? '' : _selectedTime!.format(context);

  String get _locationText => _locationController.text.trim();

  bool get _isValid =>
      _selectedDate != null &&
      _selectedTime != null &&
      _locationText.isNotEmpty;

  // ── Pickers ───────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF6C3CE1),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF6C3CE1),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // ── Confirm ───────────────────────────────────────────────────────────────

  Future<void> _onConfirm() async {
    // Screen-level guard: synchronous check before the first await so rapid
    // double-taps are dropped even before setState() has a chance to run.
    if (_isConfirming) return;

    if (!_isValid) {
      AppSnackBar.showWarning(
        context,
        'Please select a date, time, and enter a service location.',
      );
      return;
    }

    setState(() => _isConfirming = true);

    final authUser = context.read<AuthProvider>().currentUser;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    final customerId = firebaseUser?.uid ?? authUser?.id;
    final customerName = (authUser != null && authUser.name.trim().isNotEmpty)
        ? authUser.name.trim()
        : (firebaseUser?.displayName?.trim().isNotEmpty == true
            ? firebaseUser!.displayName!.trim()
            : null);
    final customerEmail =
        (authUser != null && authUser.email.trim().isNotEmpty)
            ? authUser.email.trim()
            : (firebaseUser?.email?.trim().isNotEmpty == true
                ? firebaseUser!.email!.trim()
                : null);
    final customerPhone =
        (authUser != null && authUser.phone.trim().isNotEmpty)
            ? authUser.phone.trim()
            : (firebaseUser?.phoneNumber?.trim().isNotEmpty == true
                ? firebaseUser!.phoneNumber!.trim()
                : null);

    final newBooking = BookingModel(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      customerLocation: _locationText,
      workerId: widget.booking.workerId,
      workerSkill: widget.booking.workerRole,
      workerName: widget.booking.workerName,
      role: widget.booking.workerRole,
      location: _locationText,
      date: _formattedDate,
      time: _formattedTime,
      price: widget.booking.totalAmount,
      status: 'pending',
      imageUrl: widget.booking.imageUrl,
    );

    try {
      debugPrint('STEP 1');
      await context.read<BookingProvider>().addBooking(newBooking);
      debugPrint('STEP 2');
    } catch (e) {
      debugPrint('BOOKING FAILED: $e');
      if (mounted) {
        setState(() => _isConfirming = false);
        AppSnackBar.showError(context, 'Booking failed. Please try again.');
      }
      return;
    }

    if (!mounted) return;
    context.read<ProfileProvider>().incrementBookings();
    context.read<ProfileProvider>().addToTotalSpent(
          widget.booking.totalAmount.toDouble(),
        );
    context.read<NotificationProvider>().addNotification(
          'Booking Confirmed',
          'Your booking with ${widget.booking.workerName} is confirmed',
          'booking',
        );
    AppSnackBar.showSuccess(context, 'Booking Confirmed Successfully!');
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(initialIndex: 1),
          ),
          (route) => false,
        );
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Bottom padding = system nav-bar height so the button bar never overlaps
    // the system navigation bar on phones that don't have a home button.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    final currentUserId = context.read<AuthProvider>().currentUser?.id ??
        FirebaseAuth.instance.currentUser?.uid;
    final isSelf = widget.booking.workerId == currentUserId;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      // Keep false so the keyboard doesn't resize the button bar out of view.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        // Exclude the bottom so we handle insets ourselves below.
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Confirm Booking',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Worker Summary Card
                    WorkerSummaryCard(booking: widget.booking),
                    const SizedBox(height: 20),

                    // ── Date / Time / Location pickers ─────────────────────
                    _buildPickerSection(),
                    const SizedBox(height: 20),

                    // Booking Details preview (shows real values)
                    BookingDetailsSection(booking: _effectiveBooking),
                    const SizedBox(height: 20),

                    // Price Details
                    PriceDetailsSection(booking: widget.booking),
                    const SizedBox(height: 20),

                    // Security Banner
                    const SecurityBanner(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Buttons — sits below SafeArea, respects system nav-bar
            Container(
              // Top white shadow border
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
              padding: EdgeInsets.fromLTRB(16, 14, 16, 14 + bottomInset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelf)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'You cannot book your own service.',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // Confirm Button
                    GestureDetector(
                      onTap: _isConfirming ? null : _onConfirm,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: _isValid
                              ? const Color(0xFF16A34A)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: _isConfirming
                            ? const Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: _isValid
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Confirm Booking',
                                    style: TextStyle(
                                      color: _isValid
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Cancel Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF16A34A),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
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

  // ── Picker section ────────────────────────────────────────────────────────

  Widget _buildPickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule & Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Date picker row
              _PickerRow(
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: _formattedDate.isEmpty
                    ? 'Tap to select date'
                    : _formattedDate,
                isEmpty: _selectedDate == null,
                onTap: _pickDate,
                showDivider: true,
              ),

              // Time picker row
              _PickerRow(
                icon: Icons.access_time,
                label: 'Time',
                value: _formattedTime.isEmpty
                    ? 'Tap to select time'
                    : _formattedTime,
                isEmpty: _selectedTime == null,
                onTap: _pickTime,
                showDivider: true,
              ),

              // Location text field row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 12),
                    const SizedBox(
                      width: 72,
                      child: Text(
                        'Location',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter service address',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        minLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!_isValid)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Date, time and location are required to confirm the booking.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange.shade700,
              ),
            ),
          ),
      ],
    );
  }

  /// Returns the booking model with real-time picker values for the preview.
  ConfirmBookingModel get _effectiveBooking => ConfirmBookingModel(
        workerId: widget.booking.workerId,
        workerName: widget.booking.workerName,
        workerRole: widget.booking.workerRole,
        workerRating: widget.booking.workerRating,
        workerReviews: widget.booking.workerReviews,
        isVerified: widget.booking.isVerified,
        serviceCharge: widget.booking.serviceCharge,
        bookingFee: widget.booking.bookingFee,
        location: _locationText.isEmpty ? '—' : _locationText,
        date: _formattedDate.isEmpty ? '—' : _formattedDate,
        time: _formattedTime.isEmpty ? '—' : _formattedTime,
        service: widget.booking.service,
        imageUrl: widget.booking.imageUrl,
      );
}

// ── Reusable tap-to-pick row ─────────────────────────────────────────────────

class _PickerRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEmpty;
  final VoidCallback onTap;
  final bool showDivider;

  const _PickerRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isEmpty,
    required this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey.shade600),
                const SizedBox(width: 12),
                SizedBox(
                  width: 72,
                  child: Text(
                    label,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      color: isEmpty
                          ? Colors.grey.shade400
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
