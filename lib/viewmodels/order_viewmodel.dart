import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';

class OrderViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final List<OrderModel> _orders = [];

  StreamSubscription<User?>? authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      ordersSubscription;

  final filters = const [
    'All',
    'Processing',
    'Shipped',
    'Delivered',
  ];

  String selectedFilter = 'All';

  OrderViewModel() {
    authSubscription = auth.authStateChanges().listen(listenToOrders);
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderModel> get filteredOrders {
    if (selectedFilter == 'All') {
      return orders;
    }

    return _orders.where((order) {
      return order.status == selectedFilter;
    }).toList();
  }

  void listenToOrders(User? user) {
    ordersSubscription?.cancel();
    _orders.clear();

    if (user == null) {
      notifyListeners();
      return;
    }

    ordersSubscription = firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _orders
        ..clear()
        ..addAll(
          snapshot.docs.map(
            (document) => OrderModel.fromMap(
              document.id,
              document.data(),
            ),
          ),
        );

      notifyListeners();
    });
  }

  void selectFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    ordersSubscription?.cancel();
    super.dispose();
  }
}