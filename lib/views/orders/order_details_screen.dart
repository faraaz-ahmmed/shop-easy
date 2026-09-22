import 'package:flutter/material.dart';

import '../../models/order_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/product_image.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  String get formattedDate {
    final day = order.date.day.toString().padLeft(2, '0');
    final month = order.date.month.toString().padLeft(2, '0');

    return '$day/$month/${order.date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _OrderHeader(
                status: order.status,
                date: formattedDate,
              ),
              const SizedBox(height: 20),
              const _SectionTitle(title: 'Order Items'),
              const SizedBox(height: 10),
              ...order.items.map(
                (item) => _OrderItem(item: item),
              ),
              const SizedBox(height: 20),
              const _SectionTitle(title: 'Delivery Information'),
              const SizedBox(height: 10),
              _InformationCard(
                children: [
                  _InfoRow(
                    icon: Icons.person_outline,
                    title: order.customerName,
                  ),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    title: order.phone,
                  ),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    title: order.address,
                  ),
                  _InfoRow(
                    icon: Icons.payments_outlined,
                    title: order.paymentMethod,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _SectionTitle(title: 'Payment Summary'),
              const SizedBox(height: 10),
              _InformationCard(
                children: [
                  _PriceRow(
                    title: 'Subtotal',
                    value: order.subtotal,
                  ),
                  _PriceRow(
                    title: 'Delivery Charges',
                    value: order.deliveryCharges,
                  ),
                  const Divider(height: 25),
                  _PriceRow(
                    title: 'Total',
                    value: order.total,
                    bold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  final String status;
  final String date;

  const _OrderHeader({
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F7F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Placed on $date',
                  style: const TextStyle(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _OrderItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final price = (item['price'] as num? ?? 0).toDouble();
    final quantity = (item['quantity'] as num? ?? 1).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: ProductImage(
              image: item['image'] as String? ?? '',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String? ?? 'Product',
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Size: ${item['size']}  •  Quantity: $quantity',
                  style: const TextStyle(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rs. ${(price * quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.dark,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  final List<Widget> children;

  const _InformationCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _InfoRow({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final double value;
  final bool bold;

  const _PriceRow({
    required this.title,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: bold ? AppColors.primary : AppColors.dark,
      fontSize: bold ? 18 : 15,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: style),
          Text(
            'Rs. ${value.toStringAsFixed(0)}',
            style: style,
          ),
        ],
      ),
    );
  }
}