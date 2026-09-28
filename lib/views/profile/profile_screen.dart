import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../auth/login_screen.dart';
import '../orders/orders_screen.dart';
import 'addresses_screen.dart';
import 'edit_profile_screen.dart';
import 'help_support_screen.dart';
import 'payment_methods_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  //  OPEN PAGE START 

  void openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  //  OPEN PAGE END 

  //  LOGOUT START 

  Future<void> logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('OK'),
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

  //  LOGOUT END 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  APP BAR START 

      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),

      //  APP BAR END 

      //  BODY START 

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 650,
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              //  PROFILE HEADER START 

              const _ProfileHeader(),

              //  PROFILE HEADER END 

              const SizedBox(height: 25),

              //  EDIT PROFILE START 

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

              //  EDIT PROFILE END 

              //  MY ORDERS START 

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

              //  MY ORDERS END 

              //  ADDRESSES START 

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

              //  ADDRESSES END 

              //  PAYMENT METHODS START 

              _ProfileOption(
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                onTap: () {
                  openPage(
                    context,
                    const PaymentMethodsScreen(),
                  );
                },
              ),

              //  PAYMENT METHODS END 

              //  HELP SUPPORT START 

              _ProfileOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  openPage(
                    context,
                    const HelpSupportScreen(),
                  );
                },
              ),

              //  HELP SUPPORT END 

              const SizedBox(height: 30),

              //  LOGOUT BUTTON START 

              OutlinedButton.icon(
                onPressed: () {
                  logout(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  backgroundColor:
                      const Color(0xFFFFF5F5),
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                  side: const BorderSide(
                    color: Color(0xFFFFCDD2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),

              //  LOGOUT BUTTON END 
            ],
          ),
        ),
      ),

      //  BODY END 
    );
  }
}

//  PROFILE HEADER START 

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        //  LOADING START 

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        //  LOADING END 

        final data = snapshot.data?.data();

        final savedName = data?['name'];
        final savedEmail = data?['email'];

        final name =
            savedName is String &&
                    savedName.trim().isNotEmpty
                ? savedName.trim()
                : user.displayName?.trim().isNotEmpty ==
                        true
                    ? user.displayName!.trim()
                    : 'User';

        final email =
            savedEmail is String &&
                    savedEmail.trim().isNotEmpty
                ? savedEmail.trim()
                : user.email ?? '';

        return Row(
          children: [
            //  PROFILE ICON START 

            const CircleAvatar(
              radius: 38,
              backgroundColor: Color(0xFFE5F7F0),
              child: Icon(
                Icons.person,
                color: AppColors.darkGreen,
                size: 45,
              ),
            ),

            //  PROFILE ICON END 

            const SizedBox(width: 16),

            //  USER INFO START 

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),

            //  USER INFO END 
          ],
        );
      },
    );
  }
}

//  PROFILE HEADER END 

//  PROFILE OPTION START 

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

//  PROFILE OPTION END 