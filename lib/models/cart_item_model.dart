import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int size;
  int quantity;

  CartItemModel({
    required this.product,
    required this.size,
    this.quantity = 1,
  });

  String get documentId => '${product.id}_$size';

  double get total => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'oldPrice': product.oldPrice,
      'category': product.category,
      'rating': product.rating,
      'image': product.image,
      'size': size,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> data) {
    final productId = data['productId'] as String? ?? '';

    return CartItemModel(
      product: ProductModel.fromMap(productId, data),
      size: (data['size'] as num? ?? 0).toInt(),
      quantity: (data['quantity'] as num? ?? 1).toInt(),
    );
  }
}