import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ProductImage extends StatelessWidget {
  final String image;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.image,
    this.fit = BoxFit.contain,
  });

  bool get isOnline {
    return image.startsWith('http://') ||
        image.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (isOnline) {
      return Image.network(
        image,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;

          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (_, __, ___) {
          return const _ImageError();
        },
      );
    }

    return Image.asset(
      image,
      fit: fit,
      errorBuilder: (_, __, ___) {
        return const _ImageError();
      },
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.broken_image_outlined,
        color: AppColors.grey,
        size: 50,
      ),
    );
  }
}