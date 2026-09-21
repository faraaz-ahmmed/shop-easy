import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String documentId;
  final String id;
  final double subtotal;
  final double deliveryCharges;
  final double total;
  final int itemCount;
  final String image;
  final String status;
  final String customerName;
  final String phone;
  final String address;
  final String paymentMethod;
  final DateTime date;
  final List<Map<String, dynamic>> items;

  const OrderModel({
    required this.documentId,
    required this.id,
    required this.subtotal,
    required this.deliveryCharges,
    required this.total,
    required this.itemCount,
    required this.image,
    required this.status,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.date,
    required this.items,
  });

  factory OrderModel.fromMap(
    String documentId,
    Map<String, dynamic> data,
  ) {
    final rawItems = data['items'] as List? ?? [];

    final items = rawItems
        .whereType<Map>()
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();

    final image = items.isNotEmpty
        ? items.first['image'] as String? ?? ''
        : '';

    final createdAt = data['createdAt'];

    return OrderModel(
      documentId: documentId,
      id: documentId.length > 8
          ? documentId.substring(0, 8).toUpperCase()
          : documentId,
      subtotal: (data['subtotal'] as num? ?? 0).toDouble(),
      deliveryCharges:
          (data['deliveryCharges'] as num? ?? 0).toDouble(),
      total: (data['total'] as num? ?? 0).toDouble(),
      itemCount: (data['itemCount'] as num? ?? 0).toInt(),
      image: image,
      status: data['status'] as String? ?? 'Processing',
      customerName:
          data['customerName'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      paymentMethod:
          data['paymentMethod'] as String? ??
          'Cash on Delivery',
      date: createdAt is Timestamp
          ? createdAt.toDate()
          : DateTime.now(),
      items: items,
    );
  }
}