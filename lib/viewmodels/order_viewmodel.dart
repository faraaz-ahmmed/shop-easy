import 'package:flutter/material.dart';

import '../models/order_model.dart';

class OrderViewModel extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  final filters = const [
    'All',
    'Processing',
    'Shipped',
    'Delivered',
  ];

  String selectedFilter = 'All';

  List<OrderModel> get orders {
    return List.unmodifiable(_orders);
  }

  List<OrderModel> get filteredOrders {
    if (selectedFilter == 'All') {
      return orders;
    }

    return _orders.where((order) {
      return order.status == selectedFilter;
    }).toList();
  }

  void selectFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void addOrder({
    required double total,
    required int itemCount,
    required String image,
  }) {
    final now = DateTime.now();

    _orders.insert(
      0,
      OrderModel(
        id: now.millisecondsSinceEpoch
            .toString()
            .substring(7),
        total: total,
        itemCount: itemCount,
        image: image,
        status: 'Processing',
        date: now,
      ),
    );

    notifyListeners();
  }
}