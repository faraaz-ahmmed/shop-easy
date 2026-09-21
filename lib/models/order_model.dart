import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final double total;
  final int itemCount;
  final String image;
  final String status;
  final DateTime date;

  const OrderModel({
    required this.id,
    required this.total,
    required this.itemCount,
    required this.image,
    required this.status,
    required this.date,
  });

  factory OrderModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    final items = data['items'] as List? ?? [];

    String image = '';

    if (items.isNotEmpty && items.first is Map) {
      image = items.first['image'] as String? ?? '';
    }

    final createdAt = data['createdAt'];

    return OrderModel(
      id: id.length > 8 ? id.substring(0, 8).toUpperCase() : id,
      total: (data['total'] as num? ?? 0).toDouble(),
      itemCount: (data['itemCount'] as num? ?? 0).toInt(),
      image: image,
      status: data['status'] as String? ?? 'Processing',
      date: createdAt is Timestamp
          ? createdAt.toDate()
          : DateTime.now(),
    );
  }
}