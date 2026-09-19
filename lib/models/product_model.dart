class ProductModel {
  final String id;
  final String name;
  final double price;
  final double oldPrice;
  final String category;
  final double rating;
  final String image;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.rating,
    required this.image,
  });

  int get discount {
    return ((oldPrice - price) / oldPrice * 100).round();
  }
}