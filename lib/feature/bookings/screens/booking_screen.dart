import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/app_snack_bar.dart';
import 'package:hire_near_fyp/feature/bookings/data/booking_data.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/bookings/providers/booking_provider.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/book_now_banner.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/booking_card.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/booking_section_title.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/booking_tab_bar.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0;

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
        return 'PENDING';
      case 1:
        return 'COMPLETED';
      case 2:
        return 'CANCELLED';
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
    final currentList = _getCurrentList(bookingProvider);
    return Scaffold(
      backgroundColor: Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                  Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        size: 28,
                        color: Colors.black,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C3CE1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '3',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    BookingSectionTitle(
                      title: _sectionTitle,
                      count: currentList.length,
                      color: _sectionColor,
                    ),

                    // Booking Cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: currentList.length,
                      itemBuilder: (context, index) {
                        return BookingCard(
                          booking: currentList[index],
                          onTap: () {
                            if (currentList[index].status == 'pending') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Cancel Booking'),
                                  content: Text(
                                    'Are you sure you want to cancel booking with ${currentList[index].workerName}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context
                                            .read<BookingProvider>()
                                            .cancelBookings(
                                              currentList[index].id,
                                            );

                                        AppSnackBar.showWarning(
                                          context,
                                          'Booking Cancel',
                                        );
                                      },
                                      child: Text(
                                        ' Yes, Cancel',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
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
          ],
        ),
      ),
    );
  }
}
