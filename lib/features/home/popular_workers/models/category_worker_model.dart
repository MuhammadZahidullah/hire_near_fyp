class CategoryWorkerModel {
  final int id;
  final String name;
  final String role;
  final double rating;
  final int reviews;
  final String distance;
  final int price;
  final String imageUrl;
  final bool isVerified;
  //final List<CategoryWorkerModel> worker;
  CategoryWorkerModel({
    required this.name,
    required this.id,
    required this.role,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    required this.isVerified,
    required this.price,
    required this.reviews,
    //required this.worker,
  });
}
