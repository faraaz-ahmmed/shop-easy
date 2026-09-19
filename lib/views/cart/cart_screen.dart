import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item_model.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../widgets/product_image.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              onPressed: cart.clear,
              icon: const Icon(
                Icons.delete_outline,
              ),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const _EmptyCart()
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop =
                        constraints.maxWidth >= 750;

                    if (desktop) {
                      return Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _CartItems(
                              cart: cart,
                            ),
                          ),
                          Expanded(
                            child: _OrderSummary(
                              cart: cart,
                            ),
                          ),
                        ],
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _CartItems(cart: cart),
                          _OrderSummary(cart: cart),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 90,
            color: AppColors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add products to continue shopping',
            style: TextStyle(
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItems extends StatelessWidget {
  final CartViewModel cart;

  const _CartItems({
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: cart.items.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        return _CartItem(
          item: cart.items[index],
          cart: cart,
        );
      },
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItemModel item;
  final CartViewModel cart;

  const _CartItem({
    required this.item,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
            width: 90,
            height: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ProductImage(
              image: item.product.image,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Size: ${item.size}',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rs. ${item.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onPressed: () {
                        cart.decrease(item);
                      },
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        cart.increase(item);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              cart.remove(item);
            },
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartViewModel cart;

  const _OrderSummary({
    required this.cart,
  });

  void openCheckout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.border,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _PriceRow(
            title: 'Subtotal',
            price: cart.subtotal,
          ),
          const SizedBox(height: 12),
          _PriceRow(
            title: 'Delivery Charges',
            price: cart.deliveryCharges,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Divider(),
          ),
          _PriceRow(
            title: 'Total',
            price: cart.total,
            bold: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              openCheckout(context);
            },
            child: const Text(
              'Proceed to Checkout',
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final double price;
  final bool bold;

  const _PriceRow({
    required this.title,
    required this.price,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: bold
          ? AppColors.primary
          : AppColors.dark,
      fontSize: bold ? 18 : 15,
      fontWeight: bold
          ? FontWeight.bold
          : FontWeight.normal,
    );

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: style,
        ),
        Text(
          'Rs. ${price.toStringAsFixed(0)}',
          style: style,
        ),
      ],
    );
  }
}