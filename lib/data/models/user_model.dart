class UserModel {
  final String id; // ← add Firebase UID
  final String phone; // ← add
  final String activeRole; // ← add 'user' or 'worker'
  final bool isWorker; // ← add

  final String name;
  final String email;
  final String location;
  final String? avatarUrl;
  final int bookings;
  final double rating;
  final double totalSpent;
  // Worker specific fields
  final String? skill; // ← add
  final String? experience; // ← add
  final int? price; // ← add
  final String? description; // ← add
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.activeRole,
    required this.isWorker,
    this.avatarUrl,
    this.bookings = 0,
    this.rating = 0.0,
    this.totalSpent = 0,
    this.skill,
    this.experience,
    this.price,
    this.description,
  });

  // ← Add this below constructor
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? activeRole,
    bool? isWorker,
    String? avatarUrl,
    int? bookings,
    double? rating,
    double? totalSpent,
    String? skill,
    String? experience,
    int? price,
    String? description,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      activeRole: activeRole ?? this.activeRole,
      isWorker: isWorker ?? this.isWorker,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bookings: bookings ?? this.bookings,
      rating: rating ?? this.rating,
      totalSpent: totalSpent ?? this.totalSpent,
      skill: skill ?? this.skill,
      experience: experience ?? this.experience,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }

  // Convert to Firebase Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'activeRole': activeRole,
      'isWorker': isWorker,
      'avatarUrl': avatarUrl,
      'bookings': bookings,
      'rating': rating,
      'totalSpent': totalSpent,
      'skill': skill,
      'experience': experience,
      'price': price,
      'description': description,
    };
  }

  // Create from Firebase Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      activeRole: map['activeRole'] ?? 'user',
      isWorker: map['isWorker'] ?? false,
      avatarUrl: map['avatarUrl'],
      bookings: map['bookings'] ?? 0,
      rating: map['rating']?.toDouble() ?? 0.0,
      totalSpent: map['totalSpent']?.toDouble() ?? 0,
      skill: map['skill'],
      experience: map['experience'],
      price: map['price'],
      description: map['description'],
    );
  }
}
