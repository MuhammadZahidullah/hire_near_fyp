import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/bookings/data/booking_data.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/book_now_banner.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/booking_card.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/booking_section_title.dart';
import 'package:hire_near_fyp/feature/bookings/widgets/booking_tab_bar.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0;

  // get list based on selected tab
  List<BookingModel> get _currentList {
    switch (_selectedTab) {
      case 0:
        return BookingData.pending;
      case 1:
        return BookingData.completed;
      case 2:
        return BookingData.cancelled;
      default:
        return BookingData.pending;
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
              pendingCount: BookingData.pending.length,
              completedCount: BookingData.completed.length,
              cancelledCount: BookingData.cancelled.length,
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
                      count: _currentList.length,
                      color: _sectionColor,
                    ),

                    // Booking Cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _currentList.length,
                      itemBuilder: (context, index) {
                        return BookingCard(
                          booking: _currentList[index],
                          onTap: () {},
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
