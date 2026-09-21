import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/product_upload_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/product_card.dart';
import '../cart/cart_screen.dart';
import '../category/category_screen.dart';
import '../orders/orders_screen.dart';
import '../product/product_details_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  void openCategories(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CategoryScreen()),
    );
  }

  void openOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrdersScreen()),
    );
  }

  void openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  Future<void> uploadProducts(BuildContext context) async {
    try {
      await ProductUploadService().uploadProducts();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Products uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeViewModel>();
    final cartCount = context.watch<CartViewModel>().itemCount;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => openOrders(context),
          icon: const Icon(Icons.menu),
        ),
        title: const _ShopTitle(),
        actions: [
          IconButton(
            tooltip: 'Upload products',
            onPressed: () => uploadProducts(context),
            icon: const Icon(Icons.cloud_upload_outlined),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () => openCart(context),
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 5,
                  top: 4,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartCount > 9 ? '9+' : '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: Responsive.contentWidth(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _WelcomeMessage(),
                const SizedBox(height: 16),
                TextField(
                  onChanged: home.search,
                  decoration: const InputDecoration(
                    hintText: 'Search for products...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                const _OfferBanner(),
                const SizedBox(height: 18),
                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: home.categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final category = home.categories[index];

                      return _CategoryItem(
                        name: category,
                        selected: category == home.selectedCategory,
                        onTap: () => home.selectCategory(category),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
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
                      onPressed: () => home.selectCategory('All'),
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (home.filteredProducts.isEmpty)
                  const Padding(
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
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: home.filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.gridCount(context),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio:
                          Responsive.isMobile(context) ? 0.72 : 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final product = home.filteredProducts[index];

                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) openCategories(context);
          if (index == 2) openCart(context);
          if (index == 3) openProfile(context);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            label: 'Category',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _WelcomeMessage extends StatelessWidget {
  const _WelcomeMessage();

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
        final savedName = snapshot.data?.data()?['name'];

        final name = savedName is String && savedName.trim().isNotEmpty
            ? savedName.trim()
            : user.displayName?.trim();

        return Text(
          name == null || name.isEmpty ? 'Welcome!' : 'Welcome, $name!',
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
            style: TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

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
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            color: Colors.white.withValues(alpha: 0.85),
            size: 85,
          ),
        ],
      ),
    );
  }
}

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
              backgroundColor:
                  selected ? AppColors.primary : const Color(0xFFE5F7F0),
              child: Icon(
                icon,
                color: selected ? Colors.white : AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.dark,
                fontSize: 12,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}