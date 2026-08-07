import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/worker/widgets/worker_booking_card.dart';
import 'package:provider/provider.dart';
import 'package:hire_near_fyp/feature/worker/providers/worker_dashboard_provider.dart';

class WorkerDashboard extends StatelessWidget {
  const WorkerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkerDashboardProvider>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Worker Dashboard"),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Accepted"),
              Tab(text: "Completed"),
              Tab(text: "Rejected"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingList(bookings: provider.pendingBookings, showActions: true),
            _BookingList(bookings: provider.acceptedBookings),
            _BookingList(bookings: provider.completedBookings),
            _BookingList(bookings: provider.rejectedBookings),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  final bool showActions;

  const _BookingList({required this.bookings, this.showActions = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WorkerDashboardProvider>();

    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings found"));
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (_, index) {
        final booking = bookings[index];

        return WorkerBookingCard(
          booking: booking,

          onAccept: showActions
              ? () async {
                  await provider.acceptBooking(booking.id);
                }
              : null,
          onReject: showActions
              ? () async {
                  await provider.rejectBooking(booking.id);
                }
              : null,

          onViewDetails: () {
            // We'll implement this later.
          },
        );
      },
    );
  }
}
