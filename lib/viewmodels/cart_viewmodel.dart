import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final List<CartItemModel> _items = [];

  StreamSubscription<User?>? authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      cartSubscription;

  CartViewModel() {
    authSubscription = auth.authStateChanges().listen(listenToCart);
  }

  List<CartItemModel> get items => List.unmodifiable(_items);

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

  double get deliveryCharges => _items.isEmpty ? 0 : 200;

  double get total => subtotal + deliveryCharges;

  CollectionReference<Map<String, dynamic>> cartReference(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('cart');
  }

  void listenToCart(User? user) {
    cartSubscription?.cancel();
    _items.clear();

    if (user == null) {
      notifyListeners();
      return;
    }

    cartSubscription = cartReference(user.uid).snapshots().listen((snapshot) {
      _items
        ..clear()
        ..addAll(
          snapshot.docs.map(
            (document) => CartItemModel.fromMap(document.data()),
          ),
        );

      notifyListeners();
    });
  }

  Future<void> addProduct({
    required ProductModel product,
    required int size,
    required int quantity,
  }) async {
    final user = auth.currentUser;

    if (user == null) return;

    final item = CartItemModel(
      product: product,
      size: size,
      quantity: quantity,
    );

    final document = cartReference(user.uid).doc(item.documentId);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(document);
      final oldQuantity =
          (snapshot.data()?['quantity'] as num? ?? 0).toInt();

      final data = item.toMap();
      data['quantity'] = oldQuantity + quantity;

      transaction.set(document, data);
    });
  }

  Future<void> increase(CartItemModel item) async {
    final user = auth.currentUser;

    if (user == null) return;

    await cartReference(user.uid)
        .doc(item.documentId)
        .update({
      'quantity': FieldValue.increment(1),
    });
  }

  Future<void> decrease(CartItemModel item) async {
    final user = auth.currentUser;

    if (user == null) return;

    final document = cartReference(user.uid).doc(item.documentId);

    if (item.quantity > 1) {
      await document.update({
        'quantity': FieldValue.increment(-1),
      });
    } else {
      await document.delete();
    }
  }

  Future<void> remove(CartItemModel item) async {
    final user = auth.currentUser;

    if (user == null) return;

    await cartReference(user.uid)
        .doc(item.documentId)
        .delete();
  }

  Future<void> clear() async {
    final user = auth.currentUser;

    if (user == null) return;

    final snapshot = await cartReference(user.uid).get();
    final batch = firestore.batch();

    for (final document in snapshot.docs) {
      batch.delete(document.reference);
    }

    await batch.commit();
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    cartSubscription?.cancel();
    super.dispose();
  }
}