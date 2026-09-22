import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ProductSeedService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<int> uploadProducts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products?limit=0'),
    );

    if (response.statusCode != 200) {
      throw Exception('Products download failed');
    }

    final json = jsonDecode(response.body);
    final List sourceProducts = json['products'] ?? [];

    if (sourceProducts.isEmpty) {
      throw Exception('No products found');
    }

    final batch = firestore.batch();
    const totalProducts = 320;

    for (int index = 0; index < totalProducts; index++) {
      final source = Map<String, dynamic>.from(
        sourceProducts[index % sourceProducts.length],
      );

      final originalName = source['title'] as String? ?? 'Product';
      final sourceCategory = source['category'] as String? ?? '';
      final priceInDollar =
          (source['price'] as num? ?? 10).toDouble();

      final discount =
          (source['discountPercentage'] as num? ?? 10).toDouble();

      final price = (priceInDollar * 280).round();
      final oldPrice =
          (price / (1 - discount / 100)).round();

      final isExtraProduct = index >= sourceProducts.length;

      final name = isExtraProduct
          ? '$originalName Premium Edition'
          : originalName;

      final documentId =
          'catalog_${(index + 1).toString().padLeft(3, '0')}';

      final document = firestore
          .collection('products')
          .doc(documentId);

      batch.set(document, {
        'name': name,
        'price': price,
        'oldPrice': oldPrice,
        'category': mapCategory(sourceCategory),
        'rating':
            (source['rating'] as num? ?? 4).toDouble(),
        'image': source['thumbnail'] as String? ?? '',
        'description':
            source['description'] as String? ?? '',
        'stock': (source['stock'] as num? ?? 10).toInt(),
      });
    }

    await batch.commit();

    return totalProducts;
  }

  String mapCategory(String category) {
    if ([
      'beauty',
      'fragrances',
      'skin-care',
    ].contains(category)) {
      return 'Beauty';
    }

    if ([
      'mens-shirts',
      'mens-shoes',
      'mens-watches',
      'womens-bags',
      'womens-dresses',
      'womens-jewellery',
      'womens-shoes',
      'womens-watches',
      'sunglasses',
      'tops',
    ].contains(category)) {
      return 'Fashion';
    }

    if ([
      'furniture',
      'home-decoration',
      'kitchen-accessories',
      'groceries',
    ].contains(category)) {
      return 'Home';
    }

    if ([
      'sports-accessories',
      'vehicle',
      'motorcycle',
    ].contains(category)) {
      return 'Sports';
    }

    return 'Electronics';
  }
}