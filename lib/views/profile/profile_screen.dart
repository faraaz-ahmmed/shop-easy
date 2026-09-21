import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../auth/login_screen.dart';
import '../orders/orders_screen.dart';
import 'addresses_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void showMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title coming soon'),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: AppColors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {
              showMessage(context, 'Settings');
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const _ProfileHeader(),
              const SizedBox(height: 25),
              _ProfileOption(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                onTap: () {
                  openPage(
                    context,
                    const EditProfileScreen(),
                  );
                },
              ),
              _ProfileOption(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                onTap: () {
                  openPage(
                    context,
                    const OrdersScreen(),
                  );
                },
              ),
              _ProfileOption(
                icon: Icons.location_on_outlined,
                title: 'Addresses',
                onTap: () {
                  openPage(
                    context,
                    const AddressesScreen(),
                  );
                },
              ),
              _ProfileOption(
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                onTap: () {
                  showMessage(context, 'Payment Methods');
                },
              ),
              _ProfileOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  showMessage(context, 'Help & Support');
                },
              ),
              _ProfileOption(
                icon: Icons.info_outline,
                title: 'About App',
                onTap: () {
                  showMessage(context, 'About App');
                },
              ),
              const SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: () {
                  logout(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                  side: const BorderSide(
                    color: Color(0xFFFFCDD2),
                  ),
                  backgroundColor: const Color(0xFFFFF5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();

        final savedName = data?['name'] as String?;
        final savedEmail = data?['email'] as String?;

        final name = savedName?.trim().isNotEmpty == true
            ? savedName!
            : user.displayName ?? 'User';

        final email = savedEmail?.trim().isNotEmpty == true
            ? savedEmail!
            : user.email ?? '';

        return Row(
          children: [
            const CircleAvatar(
              radius: 38,
              backgroundColor: Color(0xFFE5F7F0),
              child: Icon(
                Icons.person,
                color: AppColors.darkGreen,
                size: 45,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            icon,
            color: AppColors.dark,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.grey,
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}