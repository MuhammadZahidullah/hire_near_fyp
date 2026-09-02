import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/app_snack_bar.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/bookings/providers/booking_provider.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/book_now_banner.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/booking_card.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/booking_section_title.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/booking_tab_bar.dart';
import 'package:hire_near_fyp/feature/notifications/providers/notification_provider.dart';
import 'package:hire_near_fyp/feature/notifications/screens/notifications_screen.dart';
import 'package:hire_near_fyp/feature/review/widgets/add_reveiw_sheet.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadBookings();
    });
  }

  // get list based on selected tab
  List<BookingModel> _getCurrentList(BookingProvider provider) {
    switch (_selectedTab) {
      case 0:
        return provider.pendingBookings;
      case 1:
        return provider.completeBookings;
      case 2:
        return provider.cancelBooking;
      default:
        return provider.pendingBookings;
    }
  }

  // get section title based on tab
  String get _sectionTitle {
    switch (_selectedTab) {
      case 0:
        return 'PENDING & ACTIVE';
      case 1:
        return 'COMPLETED';
      case 2:
        return 'CANCELLED / REJECTED';
      default:
        return 'PENDING';
    }
  }

  // get section color based on tab
  Color get _sectionColor {
    switch (_selectedTab) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final currentList = _getCurrentList(bookingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'My Bookings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      Text(
                        'All your bookings in one place',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  // Notification Bell
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          size: 28,
                          color: Colors.black,
                        ),
                        if (notificationProvider.hasUnread)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF6C3CE1),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                notificationProvider.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
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

            // Tab Bar
            BookingTabBar(
              selectedIndex: _selectedTab,
              onTabSelected: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              pendingCount: bookingProvider.pendingBookings.length,
              completedCount: bookingProvider.completeBookings.length,
              cancelledCount: bookingProvider.cancelBooking.length,
            ),

            // Content
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF6C3CE1),
                onRefresh: () => context.read<BookingProvider>().loadBookings(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      BookingSectionTitle(
                        title: _sectionTitle,
                        count: currentList.length,
                        color: _sectionColor,
                      ),

                      if (bookingProvider.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF6C3CE1),
                            ),
                          ),
                        )
                      else if (currentList.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 50,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No ${_sectionTitle.toLowerCase()} bookings found',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        // Booking Cards
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: currentList.length,
                          itemBuilder: (context, index) {
                            final booking = currentList[index];

                            return BookingCard(
                              booking: booking,
                              onTap: () {
                                // Pending or Accepted
                                if (booking.status == 'pending' ||
                                    booking.status == 'accepted') {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        booking.status == 'accepted'
                                            ? 'Cancel Accepted Booking'
                                            : 'Cancel Booking',
                                      ),
                                      content: Text(
                                        'Are you sure you want to cancel booking with ${booking.workerName}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await context
                                                .read<BookingProvider>()
                                                .cancelBookings(booking.id);
                                            if (context.mounted) {
                                              context
                                                  .read<NotificationProvider>()
                                                  .addNotification(
                                                    'Booking Cancelled',
                                                    'Your booking with ${booking.workerName} has been cancelled',
                                                    'cancel',
                                                  );
                                              AppSnackBar.showWarning(
                                                context,
                                                'Booking Cancelled',
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'Yes, Cancel',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                // Completed
                                else if (booking.status == 'completed') {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) => AddReviewSheet(
                                      workerId: booking.id,
                                      workerName: booking.workerName,
                                      userName: 'Muhammad Zahidullah',
                                    ),
                                  );
                                }
                                // Cancelled / Rejected
                                else {
                                  AppSnackBar.showWarning(
                                    context,
                                    'This booking was ${booking.status}',
                                  );
                                }
                              },
                            );
                          },
                        ),

                      // Book Now Banner
                      BookNowBanner(onTap: () {}),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
