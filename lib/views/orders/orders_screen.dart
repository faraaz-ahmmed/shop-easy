import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order_model.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/order_viewmodel.dart';
import '../../widgets/product_image.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderViewModel = context.watch<OrderViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              SizedBox(
                height: 65,
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  scrollDirection: Axis.horizontal,
                  itemCount: orderViewModel.filters.length,
                  separatorBuilder: (_, _) {
                    return const SizedBox(width: 8);
                  },
                  itemBuilder: (context, index) {
                    final filter =
                        orderViewModel.filters[index];

                    final selected =
                        filter == orderViewModel.selectedFilter;

                    return ChoiceChip(
                      label: Text(filter),
                      selected: selected,
                      onSelected: (_) {
                        orderViewModel.selectFilter(filter);
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : AppColors.dark,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: orderViewModel.filteredOrders.isEmpty
                    ? const _EmptyOrders()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            orderViewModel.filteredOrders.length,
                        separatorBuilder: (_, _) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          final order =
                              orderViewModel.filteredOrders[index];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OrderDetailsScreen(
                                    order: order,
                                  ),
                                ),
                              );
                            },
                            borderRadius:
                                BorderRadius.circular(12),
                            child: _OrderCard(
                              order: order,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: AppColors.grey,
            size: 80,
          ),
          SizedBox(height: 15),
          Text(
            'No orders found',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Your placed orders will appear here',
            style: TextStyle(
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({
    required this.order,
  });

  String get formattedDate {
    final day = order.date.day.toString().padLeft(2, '0');
    final month = order.date.month.toString().padLeft(2, '0');

    return '$day/$month/${order.date.year}';
  }

  Color get statusColor {
    switch (order.status) {
      case 'Delivered':
        return AppColors.primary;

      case 'Shipped':
        return Colors.blue;

      case 'Cancelled':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.border,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 85,
            height: 85,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ProductImage(
              image: order.image,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${order.itemCount} items',
                  style: const TextStyle(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rs. ${order.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Placed on $formattedDate',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.chevron_right,
                color: AppColors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}