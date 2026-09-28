import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/product_card.dart';
import '../auth/login_screen.dart';
import '../cart/cart_screen.dart';
import '../category/category_screen.dart';
import '../orders/orders_screen.dart';
import '../product/product_details_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ================= OPEN PAGE START =================

  void openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // ================= OPEN PAGE END =================

  // ================= LOGOUT FUNCTION START =================

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

  // ================= LOGOUT FUNCTION END =================

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeViewModel>();
    final cartCount =
        context.watch<CartViewModel>().itemCount;

    return Scaffold(
      // ================= APP BAR START =================

      appBar: AppBar(
        // ================= MENU ICON START =================

        leading: IconButton(
          tooltip: 'My Orders',
          onPressed: () {
            openPage(
              context,
              const OrdersScreen(),
            );
          },
          icon: const Icon(Icons.menu),
        ),

        // ================= MENU ICON END =================

        title: const _ShopTitle(),

        actions: [
          // ================= LOGOUT ICON START =================

          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),

          // ================= LOGOUT ICON END =================
        ],
      ),

      // ================= APP BAR END =================

      // ================= BODY START =================

      body: Center(
        child: SizedBox(
          width: Responsive.contentWidth(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= WELCOME START =================

                const _WelcomeMessage(),

                // ================= WELCOME END =================

                const SizedBox(height: 16),

                // ================= SEARCH BAR START =================

                TextField(
                  onChanged: home.search,
                  decoration: const InputDecoration(
                    hintText: 'Search for products...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),

                // ================= SEARCH BAR END =================

                const SizedBox(height: 16),

                // ================= OFFER BANNER START =================

                const _OfferBanner(),

                // ================= OFFER BANNER END =================

                const SizedBox(height: 18),

                // ================= CATEGORIES START =================

                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: home.categories.length,
                    separatorBuilder: (_, _) {
                      return const SizedBox(width: 12);
                    },
                    itemBuilder: (context, index) {
                      final category =
                          home.categories[index];

                      return _CategoryItem(
                        name: category,
                        selected:
                            category ==
                            home.selectedCategory,
                        onTap: () {
                          home.selectCategory(category);
                        },
                      );
                    },
                  ),
                ),

                // ================= CATEGORIES END =================

                const SizedBox(height: 18),

                // ================= PRODUCT TITLE START =================

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Best Selling Products',
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        
                        home.selectCategory('All');
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),

                // ================= PRODUCT TITLE END =================

                const SizedBox(height: 10),

                // ================= PRODUCT GRID START =================

                if (home.filteredProducts.isEmpty)
                  const _EmptyProducts()
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount:
                        home.filteredProducts.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          Responsive.gridCount(context),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio:
                          Responsive.isMobile(context)
                          ? 0.72
                          : 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final product =
                          home.filteredProducts[index];

                      return ProductCard(
                        product: product,
                        onTap: () {
                          openPage(
                            context,
                            ProductDetailsScreen(
                              product: product,
                            ),
                          );
                        },
                      );
                    },
                  ),

                // ================= PRODUCT GRID END =================
              ],
            ),
          ),
        ),
      ),

      // ================= BODY END =================

      // ================= BOTTOM NAVIGATION START =================

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            openPage(
              context,
              const CategoryScreen(),
            );
          }

          if (index == 2) {
            openPage(
              context,
              const CartScreen(),
            );
          }

          if (index == 3) {
            openPage(
              context,
              const ProfileScreen(),
            );
          }
        },
        destinations: [
          // ================= HOME ICON START =================

          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          // ================= HOME ICON END =================

          // ================= CATEGORY ICON START =================

          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Category',
          ),

          // ================= CATEGORY ICON END =================

          // ================= CART ICON START =================

          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(
                Icons.shopping_cart_outlined,
              ),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(
                Icons.shopping_cart,
              ),
            ),
            label: 'Cart',
          ),

          // ================= CART ICON END =================

          // ================= PROFILE ICON START =================

          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),

          // ================= PROFILE ICON END =================
        ],
      ),

      // ================= BOTTOM NAVIGATION END =================
    );
  }
}

// ================= WELCOME WIDGET START =================

class _WelcomeMessage extends StatefulWidget {
  const _WelcomeMessage();

  @override
  State<_WelcomeMessage> createState() {
    return _WelcomeMessageState();
  }
}

class _WelcomeMessageState
    extends State<_WelcomeMessage> {
  late final Future<Map<String, dynamic>> welcomeData;

  @override
  void initState() {
    super.initState();
    welcomeData = loadWelcomeData();
  }

  Future<Map<String, dynamic>>
  loadWelcomeData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return {
        'name': 'User',
        'isReturning': false,
      };
    }

    final userReference = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final document = await userReference.get();
    final data = document.data();

    final savedName = data?['name'];

    final name =
        savedName is String &&
            savedName.trim().isNotEmpty
        ? savedName.trim()
        : user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : 'User';

    final isReturning =
        data?['hasLoggedInBefore'] == true;

    if (!isReturning) {
      await userReference.set(
        {
          'hasLoggedInBefore': true,
        },
        SetOptions(merge: true),
      );
    }

    return {
      'name': name,
      'isReturning': isReturning,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: welcomeData,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Text(
            'Welcome!',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        final data = snapshot.data;
        final name = data?['name'] ?? 'User';
        final isReturning =
            data?['isReturning'] == true;

        return Text(
          isReturning
              ? 'Welcome Back, $name!'
              : 'Welcome, $name!',
          style: const TextStyle(
            color: AppColors.dark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}

// ================= WELCOME WIDGET END =================

// ================= SHOP TITLE START =================

class _ShopTitle extends StatelessWidget {
  const _ShopTitle();

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        style: TextStyle(
          color: AppColors.dark,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(text: 'Shop'),
          TextSpan(
            text: 'Easy',
            style: TextStyle(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= SHOP TITLE END =================

// ================= OFFER BANNER START =================

class _OfferBanner extends StatelessWidget {
  const _OfferBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Offer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Up to 50% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Shop Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.headphones,
            color: Colors.white,
            size: 85,
          ),
        ],
      ),
    );
  }
}

// ================= OFFER BANNER END =================

// ================= CATEGORY WIDGET START =================

class _CategoryItem extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  IconData get icon {
    switch (name) {
      case 'Electronics':
        return Icons.phone_android;

      case 'Fashion':
        return Icons.checkroom;

      case 'Home':
        return Icons.home_outlined;

      case 'Beauty':
        return Icons.face_retouching_natural;

      case 'Sports':
        return Icons.sports_basketball_outlined;

      case 'Toys':
        return Icons.toys_outlined;

      default:
        return Icons.apps;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 75,
        child: Column(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: selected
                  ? AppColors.primary
                  : const Color(0xFFE5F7F0),
              child: Icon(
                icon,
                color: selected
                    ? Colors.white
                    : AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected
                    ? AppColors.primary
                    : AppColors.dark,
                fontSize: 12,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CATEGORY WIDGET END =================

// ================= EMPTY PRODUCTS START =================

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 70),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 70,
              color: AppColors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'No products found',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= EMPTY PRODUCTS END =================