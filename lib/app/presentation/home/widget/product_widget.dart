import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/resources/resource.dart';
import 'package:fakestore/app/core/widgets/optimized_image.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/presentation/home/widget/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    required this.product,
    required this.onAddToCart,
    required this.onAddToFav,
    required this.favProducts,
    required this.cartProducts,
    super.key,
  });

  final Product product;
  final void Function(Product) onAddToCart;
  final void Function(Product) onAddToFav;
  final List<Product> favProducts;
  final List<Product> cartProducts;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final isFavorite = widget.favProducts.any((p) => p.id == widget.product.id);
    return GestureDetector(
      onTap: () => Get.to(
        () => ProductDetail(
          product: widget.product,
          onAddToCart: widget.onAddToCart,
          onAddToFav: widget.onAddToFav,
          favProducts: widget.favProducts,
          cartProducts: widget.cartProducts,
        ),
      ),
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.themeC.container,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: OptimizedImage(
                width: 80,
                height: 120,
                imageUrl: widget.product.image,
                fit: BoxFit.cover,
              ).paddingSymmetric(vertical: 10),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: context.themeC.textStyle.copyWith(
                            color: context.themeC.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => widget.onAddToFav(widget.product),
                        child: SvgPicture.asset(
                          isFavorite ? R.heartFilledIcon : R.wishlistIcon,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.product.category,
                    style: context.themeC.textStyle.copyWith(
                      color: context.themeC.textSecondaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        size: 14,
                      ),
                      Text(
                        widget.product.rating.rate.toStringAsFixed(1),
                        style: context.themeC.textStyle.copyWith(
                          color: context.themeC.textSecondaryDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: context.themeC.textStyle.copyWith(
                      color: context.themeC.textSecondaryDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}
