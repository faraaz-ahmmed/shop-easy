import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_item_model.dart';

class OrderService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> placeOrder({
    required List<CartItemModel> items,
    required String name,
    required String phone,
    required String address,
    required String paymentMethod,
    required double subtotal,
    required double deliveryCharges,
    required double total,
  }) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('Please login before placing an order');
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .add({
      'items': items.map((item) => item.toMap()).toList(),
      'customerName': name,
      'phone': phone,
      'address': address,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'deliveryCharges': deliveryCharges,
      'total': total,
      'itemCount': items.fold(
        0,
        (total, item) => total + item.quantity,
      ),
      'status': 'Processing',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}