import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/auth/screens/login_screen.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/home/screens/main_screen.dart';
import 'package:hire_near_fyp/feature/notifications/providers/notification_provider.dart';
import 'package:hire_near_fyp/feature/notifications/screens/notifications_screen.dart';
import 'package:hire_near_fyp/feature/worker/providers/worker_dashboard_provider.dart';
import 'package:hire_near_fyp/feature/worker/widgets/worker_booking_card.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/providers/profile_providers.dart';
import 'package:provider/provider.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkerDashboardProvider>().loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkerDashboardProvider>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Worker Dashboard"),
          centerTitle: true,
          actions: [
            Consumer<NotificationProvider>(
              builder: (context, notifProvider, child) {
                final unread = notifProvider.unreadCount;
                return IconButton(
                  icon: Badge(
                    isLabelVisible: unread > 0,
                    label: Text(
                      unread > 9 ? '9+' : unread.toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                    child: const Icon(Icons.notifications_outlined),
                  ),
                  tooltip: 'Notifications',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                );
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Account Menu',
              onSelected: (value) async {
                if (value == 'customer_mode') {
                  context.read<ProfileProvider>().loadProfile();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  );
                } else if (value == 'logout') {
                  await context.read<AuthProvider>().logout();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'customer_mode',
                  child: Row(
                    children: [
                      Icon(Icons.storefront_outlined, color: Color(0xFF6C3CE1)),
                      SizedBox(width: 12),
                      Text('Find Services'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
        body: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6C3CE1),
                ),
              )
            : TabBarView(
                children: [
                  _BookingList(
                    bookings: provider.pendingBookings,
                    isPendingTab: true,
                  ),
                  _BookingList(
                    bookings: provider.acceptedBookings,
                    isAcceptedTab: true,
                  ),
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
  final bool isPendingTab;
  final bool isAcceptedTab;

  const _BookingList({
    required this.bookings,
    this.isPendingTab = false,
    this.isAcceptedTab = false,
  });

  void _showBookingDetails(BuildContext context, BookingModel booking) {
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'accepted':
          return Colors.blue;
        case 'completed':
          return Colors.green;
        case 'rejected':
        case 'cancelled':
          return Colors.red;
        case 'pending':
        default:
          return Colors.orange;
      }
    }

    Widget buildDetailRow(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF6C3CE1)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(booking.status).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      booking.status.toUpperCase(),
                      style: TextStyle(
                        color: getStatusColor(booking.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              buildDetailRow(
                Icons.person_outline,
                'Customer Name',
                (booking.customerName != null &&
                        booking.customerName!.trim().isNotEmpty)
                    ? booking.customerName!.trim()
                    : 'Customer',
              ),
              buildDetailRow(
                Icons.phone_outlined,
                'Customer Phone',
                (booking.customerPhone != null &&
                        booking.customerPhone!.trim().isNotEmpty)
                    ? booking.customerPhone!.trim()
                    : 'Not available',
              ),
              buildDetailRow(
                Icons.email_outlined,
                'Customer Email',
                (booking.customerEmail != null &&
                        booking.customerEmail!.trim().isNotEmpty)
                    ? booking.customerEmail!.trim()
                    : 'Not available',
              ),
              buildDetailRow(
                Icons.work_outline,
                'Service',
                booking.role.trim().isNotEmpty
                    ? booking.role.trim()
                    : 'Not available',
              ),
              buildDetailRow(
                Icons.location_on_outlined,
                'Location',
                booking.location.trim().isNotEmpty
                    ? booking.location.trim()
                    : (booking.customerLocation != null &&
                            booking.customerLocation!.trim().isNotEmpty
                        ? booking.customerLocation!.trim()
                        : 'Not available'),
              ),
              buildDetailRow(
                Icons.calendar_today_outlined,
                'Date & Time',
                '${booking.date.trim().isNotEmpty ? booking.date.trim() : 'Date not set'} • ${booking.time.trim().isNotEmpty ? booking.time.trim() : 'Time not set'}',
              ),
              buildDetailRow(
                Icons.payments_outlined,
                'Service Fee',
                'PKR ${booking.price}',
              ),
              buildDetailRow(
                Icons.tag,
                'Booking ID',
                '#${booking.id}',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C3CE1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WorkerDashboardProvider>();

    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings found"));
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadBookings(),
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

          return WorkerBookingCard(
            booking: booking,
            onAccept: isPendingTab
                ? () async {
                    await provider.acceptBooking(booking.id);
                  }
                : null,
            onReject: isPendingTab
                ? () async {
                    await provider.rejectBooking(booking.id);
                  }
                : null,
            onComplete: isAcceptedTab
                ? () async {
                    await provider.completeBooking(booking.id);
                  }
                : null,
            onViewDetails: () {
              _showBookingDetails(context, booking);
            },
          );
        },
      ),
    );
  }
}
