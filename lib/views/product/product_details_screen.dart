import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../widgets/product_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() {
    return _ProductDetailsScreenState();
  }
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {
  int quantity = 1;
  int selectedSize = 8;

  final sizes = [7, 8, 9, 10, 11];

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity == 1) return;

    setState(() {
      quantity--;
    });
  }

  void selectSize(int size) {
    setState(() {
      selectedSize = size;
    });
  }

  void addToCart() {
    context.read<CartViewModel>().addProduct(
      product: widget.product,
      size: selectedSize,
      quantity: quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product.name} added to cart',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 900,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final desktop =
                    constraints.maxWidth >= 650;

                if (desktop) {
                  return Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _ProductImage(
                          product: product,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: _ProductInformation(
                          product: product,
                          quantity: quantity,
                          selectedSize: selectedSize,
                          sizes: sizes,
                          increaseQuantity:
                              increaseQuantity,
                          decreaseQuantity:
                              decreaseQuantity,
                          selectSize: selectSize,
                          addToCart: addToCart,
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _ProductImage(
                      product: product,
                    ),
                    const SizedBox(height: 25),
                    _ProductInformation(
                      product: product,
                      quantity: quantity,
                      selectedSize: selectedSize,
                      sizes: sizes,
                      increaseQuantity:
                          increaseQuantity,
                      decreaseQuantity:
                          decreaseQuantity,
                      selectSize: selectSize,
                      addToCart: addToCart,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final ProductModel product;

  const _ProductImage({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ProductImage(
        image: product.image,
      ),
    );
  }
}

class _ProductInformation extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final int selectedSize;
  final List<int> sizes;
  final VoidCallback increaseQuantity;
  final VoidCallback decreaseQuantity;
  final VoidCallback addToCart;
  final ValueChanged<int> selectSize;

  const _ProductInformation({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.sizes,
    required this.increaseQuantity,
    required this.decreaseQuantity,
    required this.addToCart,
    required this.selectSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(
            color: AppColors.dark,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              'Rs. ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                color: AppColors.dark,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Rs. ${product.oldPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                color: AppColors.grey,
                decoration:
                    TextDecoration.lineThrough,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${product.discount}% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: AppColors.yellow,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              '${product.rating} (120 reviews)',
            ),
          ],
        ),
        const SizedBox(height: 25),
        const Text(
          'Description',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Comfortable and stylish '
          '${product.name.toLowerCase()} for everyday use. '
          'High-quality material with a modern design.',
          style: const TextStyle(
            color: AppColors.grey,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Size',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: sizes.map((size) {
            final selected =
                size == selectedSize;

            return ChoiceChip(
              label: Text('$size'),
              selected: selected,
              onSelected: (_) {
                selectSize(size);
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected
                    ? Colors.white
                    : AppColors.dark,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.border,
                ),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: decreaseQuantity,
                    icon: const Icon(
                      Icons.remove,
                    ),
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: increaseQuantity,
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: addToCart,
                child: const Text(
                  'Add to Cart',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}