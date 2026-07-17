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

  // ← Add this below constructor
  UserModel copyWith({
    String? name,
    String? email,
    String? location,
    String? avatarUrl,
    int? bookings,
    double? rating,
    double? totalSpent,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bookings: bookings ?? this.bookings,
      rating: rating ?? this.rating,
      totalSpent: totalSpent ?? this.totalSpent,
    );
  }
}
