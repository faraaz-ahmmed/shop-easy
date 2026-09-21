import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/order_service.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/cart_viewmodel.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  String paymentMethod = 'Cash on Delivery';
  bool isPlacingOrder = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void selectPayment(String value) {
    setState(() {
      paymentMethod = value;
    });
  }

  Future<void> placeOrder() async {
    if (!formKey.currentState!.validate()) return;

    final cart = context.read<CartViewModel>();

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
        ),
      );
      return;
    }

    setState(() {
      isPlacingOrder = true;
    });

    try {
      final items = List.of(cart.items);
      final total = cart.total;

      await OrderService().placeOrder(
        items: items,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        paymentMethod: paymentMethod,
        subtotal: cart.subtotal,
        deliveryCharges: cart.deliveryCharges,
        total: total,
      );

      await cart.clear();

      if (!mounted) return;

      setState(() {
        isPlacingOrder = false;
      });

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 60,
            ),
            title: const Text('Order Placed'),
            content: const Text(
              'Your order has been placed successfully.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Continue'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isPlacingOrder = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Information',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your full name';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: '03XX XXXXXXX',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 11) {
                        return 'Enter a valid phone number';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: addressController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      hintText: 'Enter your delivery address',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your delivery address';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _PaymentOption(
                    title: 'Cash on Delivery',
                    icon: Icons.payments_outlined,
                    value: 'Cash on Delivery',
                    selectedValue: paymentMethod,
                    onChanged: selectPayment,
                  ),
                  _PaymentOption(
                    title: 'JazzCash / EasyPaisa',
                    icon: Icons.account_balance_wallet_outlined,
                    value: 'JazzCash / EasyPaisa',
                    selectedValue: paymentMethod,
                    onChanged: selectPayment,
                  ),
                  _PaymentOption(
                    title: 'Card Payment',
                    icon: Icons.credit_card,
                    value: 'Card Payment',
                    selectedValue: paymentMethod,
                    onChanged: selectPayment,
                  ),
                  const SizedBox(height: 25),
                  Container(
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
                        _SummaryRow(
                          title: 'Subtotal',
                          value: cart.subtotal,
                        ),
                        const SizedBox(height: 10),
                        _SummaryRow(
                          title: 'Delivery Charges',
                          value: cart.deliveryCharges,
                        ),
                        const Divider(height: 28),
                        _SummaryRow(
                          title: 'Total',
                          value: cart.total,
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isPlacingOrder ? null : placeOrder,
                      child: isPlacingOrder
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Place Order'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const _PaymentOption({
    required this.title,
    required this.icon,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == selectedValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE5F7F0)
              : Colors.white,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected
                  ? AppColors.primary
                  : AppColors.dark,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected
                  ? AppColors.primary
                  : AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final double value;
  final bool bold;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: bold ? AppColors.primary : AppColors.dark,
      fontSize: bold ? 18 : 15,
      fontWeight: bold
          ? FontWeight.bold
          : FontWeight.normal,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: style,
        ),
        Text(
          'Rs. ${value.toStringAsFixed(0)}',
          style: style,
        ),
      ],
    );
  }
}