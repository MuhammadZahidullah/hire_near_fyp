import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';
//'import 'package:hire_near_fyp/feature/booking_confirm/widgets/booking_detail_row.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/booking_details_row.dart';

class BookingDetailsSection extends StatelessWidget {
  final ConfirmBookingModel booking;

  const BookingDetailsSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 12),

        // Details Container
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              BookingDetailRow(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: booking.location,
              ),
              BookingDetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: booking.date,
              ),
              BookingDetailRow(
                icon: Icons.access_time,
                label: 'Time',
                value: booking.time,
              ),
              BookingDetailRow(
                icon: Icons.home_repair_service_outlined,
                label: 'Service',
                value: booking.service,
                showDivider: false, // ← last row
              ),
            ],
          ),
        ),
      ],
    );
  }
}
