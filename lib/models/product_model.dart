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

  factory ProductModel.fromMap(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      name: data['name'] as String? ?? '',
      price: (data['price'] as num? ?? 0).toDouble(),
      oldPrice: (data['oldPrice'] as num? ?? 0).toDouble(),
      category: data['category'] as String? ?? '',
      rating: (data['rating'] as num? ?? 0).toDouble(),
      image: data['image'] as String? ?? '',
    );
  }

  int get discount {
    if (oldPrice <= 0) return 0;
    return ((oldPrice - price) / oldPrice * 100).round();
  }
}