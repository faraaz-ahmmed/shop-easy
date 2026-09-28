import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() {
    return _PaymentMethodsScreenState();
  }
}

class _PaymentMethodsScreenState
    extends State<PaymentMethodsScreen> {
  String selectedMethod = 'Cash on Delivery';

  void selectMethod(String method) {
    setState(() {
      selectedMethod = method;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$method selected'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= APP BAR START =================

      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),

      // ================= APP BAR END =================

      // ================= BODY START =================

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 650,
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Choose Payment Method',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select how you want to pay for your order.',
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 25),

              // ================= CASH PAYMENT START =================

              _PaymentCard(
                icon: Icons.payments_outlined,
                title: 'Cash on Delivery',
                subtitle: 'Pay when your order arrives',
                selected:
                    selectedMethod == 'Cash on Delivery',
                onTap: () {
                  selectMethod('Cash on Delivery');
                },
              ),

              // ================= CASH PAYMENT END =================

              const SizedBox(height: 12),

              // ================= CARD PAYMENT START =================

              _PaymentCard(
                icon: Icons.credit_card,
                title: 'Credit / Debit Card',
                subtitle: 'Visa, Mastercard or UnionPay',
                selected:
                    selectedMethod ==
                    'Credit / Debit Card',
                onTap: () {
                  selectMethod('Credit / Debit Card');
                },
              ),

              // ================= CARD PAYMENT END =================

              const SizedBox(height: 12),

              // ================= EASYPAISA START =================

              _PaymentCard(
                icon: Icons.phone_android,
                title: 'Easypaisa',
                subtitle: 'Pay using your Easypaisa account',
                selected:
                    selectedMethod == 'Easypaisa',
                onTap: () {
                  selectMethod('Easypaisa');
                },
              ),

              // ================= EASYPAISA END =================

              const SizedBox(height: 12),

              // ================= JAZZCASH START =================

              _PaymentCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'JazzCash',
                subtitle: 'Pay using your JazzCash account',
                selected:
                    selectedMethod == 'JazzCash',
                onTap: () {
                  selectMethod('JazzCash');
                },
              ),

              // ================= JAZZCASH END =================
            ],
          ),
        ),
      ),

      // ================= BODY END =================
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? const Color(0xFFE5F7F0)
          : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    const Color(0xFFE5F7F0),
                child: Icon(
                  icon,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: title,
                groupValue: selectedMethodValue(
                  selected,
                  title,
                ),
                onChanged: (_) {
                  onTap();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? selectedMethodValue(
    bool selected,
    String title,
  ) {
    return selected ? title : null;
  }
}