import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSeedService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final categories = const [
    'Electronics',
    'Fashion',
    'Home',
    'Beauty',
    'Sports',
    'Toys',
  ];

  final names = const [
    'Smart Watch',
    'Wireless Headphones',
    'Bluetooth Speaker',
    'Sports Shoes',
    'Casual Shirt',
    'Travel Backpack',
    'Table Lamp',
    'Wall Clock',
    'Coffee Maker',
    'Face Serum',
    'Perfume',
    'Hair Dryer',
    'Football',
    'Cricket Bat',
    'Yoga Mat',
    'Toy Car',
    'Building Blocks',
    'Teddy Bear',
    'Smart Phone',
    'Laptop Bag',
  ];

  final images = const [
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800',
    'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800',
    'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800',
    'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=800',
  ];

  Future<void> uploadProducts() async {
    final batch = firestore.batch();

    for (int index = 1; index <= 320; index++) {
      final name = names[(index - 1) % names.length];
      final category =
          categories[(index - 1) % categories.length];

      final price = 500 + (index * 137) % 25000;
      final oldPrice = price + 500 + (index % 5) * 300;
      final rating = 3.5 + (index % 15) / 10;

      final id = 'product_${index.toString().padLeft(3, '0')}';

      final document = firestore
          .collection('products')
          .doc(id);

      batch.set(document, {
        'name': '$name $index',
        'price': price,
        'oldPrice': oldPrice,
        'category': category,
        'rating': rating,
        'image': images[(index - 1) % images.length],
      });
    }

    await batch.commit();
  }
}