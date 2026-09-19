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
}