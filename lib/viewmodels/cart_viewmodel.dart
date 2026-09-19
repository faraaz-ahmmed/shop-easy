import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items {
    return List.unmodifiable(_items);
  }

  int get itemCount {
    return _items.fold(
      0,
      (total, item) => total + item.quantity,
    );
  }

  double get subtotal {
    return _items.fold(
      0,
      (total, item) => total + item.total,
    );
  }

  double get deliveryCharges {
    return _items.isEmpty ? 0 : 200;
  }

  double get total {
    return subtotal + deliveryCharges;
  }

  void addProduct({
    required ProductModel product,
    required int size,
    required int quantity,
  }) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.size == size,
    );

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItemModel(
          product: product,
          size: size,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
  }

  void increase(CartItemModel item) {
    item.quantity++;
    notifyListeners();
  }

  void decrease(CartItemModel item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }

    notifyListeners();
  }

  void remove(CartItemModel item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}