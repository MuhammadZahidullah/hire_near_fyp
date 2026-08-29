class CategoryWorkerModel {
  final int id;

  // Firebase Auth UID of the worker
  String? workerId;

  final String name;
  final String role;
  final double rating;
  final int reviews;
  final String distance;
  final int price;
  final String imageUrl;
  final bool isVerified;

  CategoryWorkerModel({
    required this.id,
    this.workerId,
    required this.name,
    required this.role,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    required this.isVerified,
    required this.price,
    required this.reviews,
  });
}
