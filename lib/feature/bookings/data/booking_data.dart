import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';

class BookingData {
  static List<BookingModel> bookings = [
    // Pending bookings
    BookingModel(
      id: 1,
      workerName: 'Inam Plumbing Service',
      role: 'Plumber',
      location: 'Swat matta, dda',
      date: '12 May 2024',
      time: '2:00 PM',
      price: 1500,
      status: 'pending',
      imageUrl: '',
    ),
    BookingModel(
      id: 2,
      workerName: 'Usman Electrician',
      role: 'Electrician',
      location: 'Johar Town, Lahore',
      date: '13 May 2024',
      time: '11:00 AM',
      price: 1200,
      status: 'pending',
      imageUrl: '',
    ),

    // Completed bookings
    BookingModel(
      id: 3,
      workerName: 'CleanHome Services',
      role: 'Cleaner',
      location: 'Bahria Town, Lahore',
      date: '5 May 2024',
      time: '10:00 AM',
      price: 800,
      status: 'completed',
      imageUrl: '',
    ),
    BookingModel(
      id: 4,
      workerName: 'Hamza Carpenter',
      role: 'Carpenter',
      location: 'Maidan, laloo',
      date: '1 May 2024',
      time: '9:00 AM',
      price: 2000,
      status: 'completed',
      imageUrl: '',
    ),
    BookingModel(
      id: 5,
      workerName: 'Naveed Mechanic',
      role: 'Mechanic',
      location: 'Upper Dir, Wary',
      date: '28 Apr 2024',
      time: '3:00 PM',
      price: 1800,
      status: 'completed',
      imageUrl: '',
    ),
    BookingModel(
      id: 6,
      workerName: 'Inam truck Driver',
      role: 'Driver',
      location: 'Cantt, Lahore',
      date: '25 Apr 2024',
      time: '8:00 AM',
      price: 500,
      status: 'completed',
      imageUrl: '',
    ),

    // Cancelled bookings
    BookingModel(
      id: 7,
      workerName: 'Yaseen Electrician',
      role: 'Electrician',
      location: 'Model Town, Lahore',
      date: '28 Apr 2024',
      time: '3:00 PM',
      price: 1300,
      status: 'cancelled',
      imageUrl: '',
    ),
  ];

  // helper getters
  static List<BookingModel> get pending =>
      bookings.where((b) => b.status == 'pending').toList();

  static List<BookingModel> get completed =>
      bookings.where((b) => b.status == 'completed').toList();

  static List<BookingModel> get cancelled =>
      bookings.where((b) => b.status == 'cancelled').toList();
}
