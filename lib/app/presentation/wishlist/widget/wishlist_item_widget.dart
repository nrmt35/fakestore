import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/resources/resource.dart';
import 'package:fakestore/app/core/widgets/button_widget.dart';
import 'package:fakestore/app/core/widgets/optimized_image.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WishlistItemWidget extends StatefulWidget {
  const WishlistItemWidget({
    required this.product,
    required this.favProducts,
    required this.cartProducts,
    required this.onAddToCart,
    required this.onAddToFav,
    super.key,
  });

  final Product product;
  final List<Product> favProducts;
  final List<Product> cartProducts;
  final void Function(Product) onAddToCart;
  final void Function(Product) onAddToFav;

  @override
  State<WishlistItemWidget> createState() => _WishlistItemWidgetState();
}

class _WishlistItemWidgetState extends State<WishlistItemWidget> {
  @override
  Widget build(BuildContext context) {
    final isFavorite = widget.favProducts.any((p) => p.id == widget.product.id);
    final isInCart = widget.cartProducts.any((p) => p.id == widget.product.id);

    return DecoratedBox(
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
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: context.themeC.textStyle.copyWith(
                    color: context.themeC.textSecondaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                ButtonWidget(
                  type: ButtonType.light,
                  label: isInCart ? context.t.alreadyInCart : context.t.addToCart,
                  onTap: () {
                    widget.onAddToCart(widget.product);
                    setState(() {});
                  },
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          SizedBox(width: 14),
        ],
      ),
    );
  }
}
