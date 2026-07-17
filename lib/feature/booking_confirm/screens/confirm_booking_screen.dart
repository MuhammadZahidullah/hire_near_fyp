import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/app_snack_bar.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/booking_detail_section.dart';
//import 'package:hire_near_fyp/feature/booking_confirm/widgets/booking_details_section.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/price_detail_section.dart';
//import 'package:hire_near_fyp/feature/booking_confirm/widgets/price_details_section.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/security_banner.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/worker_summary_card.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/bookings/providers/booking_provider.dart';
import 'package:hire_near_fyp/feature/home/screens/main_screen.dart';
import 'package:hire_near_fyp/feature/notifications/providers/notification_provider.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/providers/profile_providers.dart';
import 'package:provider/provider.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final ConfirmBookingModel booking;

  const ConfirmBookingScreen({super.key, required this.booking});

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
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
                  SizedBox(width: 36),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Worker Summary Card
                    WorkerSummaryCard(booking: widget.booking),
                    SizedBox(height: 20),

                    // Booking Details
                    BookingDetailsSection(booking: widget.booking),
                    SizedBox(height: 20),

                    // Price Details
                    PriceDetailsSection(booking: widget.booking),
                    SizedBox(height: 20),

                    // Security Banner
                    SecurityBanner(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  // Confirm Button
                  GestureDetector(
                    onTap: () {
                      var newBooking = BookingModel(
                        id: DateTime.now().millisecondsSinceEpoch,
                        workerName: widget.booking.workerName,
                        role: widget.booking.workerRole,
                        location: widget.booking.location,
                        date: widget.booking.date,
                        time: widget.booking.time,
                        price: widget.booking.totalAmount,
                        status: 'pending',
                        imageUrl: widget.booking.imageUrl,
                      );

                      context.read<BookingProvider>().addBooking(newBooking);
                      context.read<ProfileProvider>().incrementBookings();
                      context.read<ProfileProvider>().addToTotalSpent(
                        widget.booking.totalAmount.toDouble(),
                      );
                      // After addBooking
                      context.read<NotificationProvider>().addNotification(
                        'Booking Confirmed',
                        'Your booking with ${widget.booking.workerName} is confirmed',
                        'booking',
                      );
                      AppSnackBar.showSuccess(
                        context,
                        'Booking Confirmed Successfully!',
                      );
                      Future.delayed(Duration(seconds: 2), () {
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
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Confirm Booking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Cancel Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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
