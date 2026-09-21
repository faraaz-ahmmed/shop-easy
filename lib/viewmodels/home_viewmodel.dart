import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class HomeViewModel extends ChangeNotifier {
  String searchText = '';
  String selectedCategory = 'All';
  String? errorMessage;
  bool isLoading = true;

  final categories = const [
    'All',
    'Electronics',
    'Fashion',
    'Home',
    'Beauty',
    'Sports',
    'Toys',
  ];

  List<ProductModel> products = [];
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _subscription;

  HomeViewModel() {
    _subscription = FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen(
      (snapshot) {
        products = snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
            .toList();
        errorMessage = null;
        isLoading = false;
        notifyListeners();
      },
      onError: (Object error) {
        errorMessage = error.toString();
        isLoading = false;
        notifyListeners();
      },
    );
  }

  List<ProductModel> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      final matchesCategory = selectedCategory == 'All' ||
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

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}