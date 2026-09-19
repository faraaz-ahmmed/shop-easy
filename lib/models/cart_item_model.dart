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

  double get total {
    return product.price * quantity;
  }
}