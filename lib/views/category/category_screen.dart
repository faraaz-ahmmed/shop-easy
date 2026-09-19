import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../viewmodels/home_viewmodel.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const categories = [
    _CategoryData(
      name: 'Electronics',
      icon: Icons.phone_android,
      color: Color(0xFFE3F2FD),
    ),
    _CategoryData(
      name: 'Fashion',
      icon: Icons.checkroom,
      color: Color(0xFFFFF3E0),
    ),
    _CategoryData(
      name: 'Home',
      icon: Icons.chair_outlined,
      color: Color(0xFFE8F5E9),
    ),
    _CategoryData(
      name: 'Beauty',
      icon: Icons.face_retouching_natural,
      color: Color(0xFFFCE4EC),
    ),
    _CategoryData(
      name: 'Sports',
      icon: Icons.sports_basketball_outlined,
      color: Color(0xFFEDE7F6),
    ),
    _CategoryData(
      name: 'Toys',
      icon: Icons.toys_outlined,
      color: Color(0xFFFFF8E1),
    ),
  ];

  int gridCount(double width) {
    if (width >= 1000) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final home = context.read<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      gridCount(constraints.maxWidth),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return _CategoryCard(
                    category: category,
                    onTap: () {
                      home.selectCategory(category.name);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _CategoryData category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: category.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              color: AppColors.darkGreen,
              size: 65,
            ),
            const SizedBox(height: 14),
            Text(
              category.name,
              style: const TextStyle(
                color: AppColors.dark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  final String name;
  final IconData icon;
  final Color color;

  const _CategoryData({
    required this.name,
    required this.icon,
    required this.color,
  });
}