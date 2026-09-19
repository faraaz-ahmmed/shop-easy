import 'package:flutter/material.dart';

import '../models/product_model.dart';

class HomeViewModel extends ChangeNotifier {
  String searchText = '';
  String selectedCategory = 'All';

  final categories = const [
    'All',
    'Electronics',
    'Fashion',
    'Home',
    'Beauty',
    'Sports',
    'Toys',
  ];

  final products = const [
    ProductModel(
      id: '1',
      name: 'Sports Shoes',
      price: 2499,
      oldPrice: 3999,
      category: 'Fashion',
      rating: 4.5,
      image:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    ),
    ProductModel(
      id: '2',
      name: 'Smart Watch',
      price: 4999,
      oldPrice: 6499,
      category: 'Electronics',
      rating: 4.7,
      image:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
    ),
    ProductModel(
      id: '3',
      name: 'Headphones',
      price: 3499,
      oldPrice: 4999,
      category: 'Electronics',
      rating: 4.6,
      image:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
    ),
    ProductModel(
      id: '4',
      name: 'Smart Phone',
      price: 54999,
      oldPrice: 59999,
      category: 'Electronics',
      rating: 4.8,
      image:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    ),
  ];

  List<ProductModel> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      final matchesCategory =
          selectedCategory == 'All' ||
          product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void search(String value) {
    searchText = value;
    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}