import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= APP BAR START =================

      appBar: AppBar(
        title: const Text('Help & Support'),
      ),

      // ================= APP BAR END =================

      // ================= BODY START =================

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(
                Icons.support_agent,
                color: AppColors.primary,
                size: 75,
              ),
              const SizedBox(height: 12),
              const Text(
                'How can we help you?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              // ================= CONTACT START =================

              const _SupportTile(
                icon: Icons.email_outlined,
                title: 'Email Support',
                subtitle: 'support@shopeasy.com',
              ),
              const _SupportTile(
                icon: Icons.phone_outlined,
                title: 'Call Support',
                subtitle: '+92 300 1234567',
              ),
              const _SupportTile(
                icon: Icons.schedule,
                title: 'Support Time',
                subtitle: 'Monday to Saturday, 9 AM - 6 PM',
              ),

              // ================= CONTACT END =================

              const SizedBox(height: 25),

              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // ================= FAQ START =================

              const _QuestionTile(
                question: 'How can I place an order?',
                answer:
                    'Open a product, select quantity and size, add it to cart and continue to checkout.',
              ),
              const _QuestionTile(
                question: 'How can I track my order?',
                answer:
                    'Open My Profile and select My Orders to check your order status.',
              ),
              const _QuestionTile(
                question: 'Can I cancel my order?',
                answer:
                    'You can contact support while your order status is still Processing.',
              ),
              const _QuestionTile(
                question: 'Which payment methods are available?',
                answer:
                    'Cash on Delivery, Card, Easypaisa and JazzCash are available.',
              ),

              // ================= FAQ END =================
            ],
          ),
        ),
      ),

      // ================= BODY END =================
    );
  }
}

class _SupportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SupportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE5F7F0),
          child: Icon(
            icon,
            color: AppColors.darkGreen,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final String question;
  final String answer;

  const _QuestionTile({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        children: [
          Text(
            answer,
            style: const TextStyle(
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}