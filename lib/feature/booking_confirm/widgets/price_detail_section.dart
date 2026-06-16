import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';
import 'package:hire_near_fyp/feature/booking_confirm/widgets/price_row.dart';

class PriceDetailsSection extends StatelessWidget {
  final ConfirmBookingModel booking;

  const PriceDetailsSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          'Price Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 12),

        // Price Container
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
              PriceRow(
                label: 'Service Charge',
                value: 'Rs. ${booking.serviceCharge}',
              ),
              PriceRow(
                label: 'Booking Fee',
                value: 'Rs. ${booking.bookingFee}',
              ),
              PriceRow(
                label: 'Total Amount',
                value: 'Rs. ${booking.totalAmount}',
                isTotal: true,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
