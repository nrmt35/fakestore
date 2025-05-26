import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/widgets/optimized_image.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({
    required this.product,
    required this.cartProducts,
    required this.onAddToCart,
    required this.onRemoveFromBasket,
    required this.onDecreaseAmount,
    super.key,
  });

  final Product product;
  final List<Product> cartProducts;
  final void Function(Product) onAddToCart;
  final void Function(Product) onRemoveFromBasket;
  final void Function(Product) onDecreaseAmount;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) => Dismissible(
        key: Key(widget.product.id.toString()),
        background: ColoredBox(
          color: context.themeC.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ).paddingOnly(right: 30),
          ),
        ),
        onDismissed: (direction) => widget.onRemoveFromBasket(widget.product),
        child: Row(
          children: [
            SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: OptimizedImage(
                width: 50,
                height: 70,
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
                  Text(
                    widget.product.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.themeC.textStyle.copyWith(
                      color: context.themeC.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: context.themeC.divider),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => widget.onDecreaseAmount(widget.product),
                            child: Icon(
                              Icons.remove_circle_outline_rounded,
                              color: context.themeC.textPrimary,
                            ).paddingAll(8),
                          ),
                          VerticalDivider(
                            color: context.themeC.divider,
                            width: 1,
                            thickness: 1,
                          ),
                          SizedBox(width: 20),
                          Text(
                            widget.product.quantity.toString(),
                            style: context.themeC.textStyle.copyWith(
                              color: context.themeC.textSecondaryDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 20),
                          VerticalDivider(
                            color: context.themeC.divider,
                            width: 1,
                            thickness: 1,
                          ),
                          GestureDetector(
                            onTap: () => widget.onAddToCart(widget.product),
                            child: Icon(
                              Icons.add_circle_outline_rounded,
                              color: context.themeC.textPrimary,
                            ).paddingAll(8),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
            SizedBox(width: 10),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: context.themeC.textStyle.copyWith(
                color: context.themeC.textSecondaryDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      );
}
