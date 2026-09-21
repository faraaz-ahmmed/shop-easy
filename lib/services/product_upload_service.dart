import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ProductUploadService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> uploadProducts() async {
    final jsonString =
        await rootBundle.loadString('assets/data/products.json');

    final List products = jsonDecode(jsonString);
    final batch = firestore.batch();

    for (final product in products) {
      final document = firestore.collection('products').doc();
      batch.set(document, product);
    }

    await batch.commit();
  }
}