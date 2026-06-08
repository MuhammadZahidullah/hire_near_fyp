class UserModel {
  final String name;
  final String email;
  final String location;
  final String? avatarUrl;
  final int bookings;
  final double rating;
  final double totalSpent;
  const UserModel({
     this.avatarUrl,
    required this.bookings,
    required this.email,
    required this.location,
    required this.name,
    required this.rating,
    required this.totalSpent,
  });
}
