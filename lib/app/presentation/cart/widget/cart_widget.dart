import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/resources/resource.dart';
import 'package:fakestore/app/core/widgets/button_widget.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/presentation/cart/widget/cart_item_widget.dart';
import 'package:fakestore/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({
    required this.cartProducts,
    required this.onAddToCart,
    required this.onRemoveFromBasket,
    required this.onDecreaseAmount,
    super.key,
  });

  final List<Product> cartProducts;
  final void Function(Product) onAddToCart;
  final void Function(Product) onRemoveFromBasket;
  final void Function(Product) onDecreaseAmount;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  double get totalCartPrice => widget.cartProducts.fold(
        0,
        (sum, product) => sum + (product.price * product.quantity),
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.t.cart,
                    style: context.themeC.textStyle.copyWith(
                      color: context.themeC.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: context.themeC.backgroundPrimary,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset(R.logoutIcon),
                      ),
                      SizedBox(height: 2),
                      Text(
                        context.t.logout,
                        style: context.themeC.textStyle.copyWith(
                          color: context.themeC.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(
              horizontal: 24,
            ),
            SizedBox(height: 10),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList.separated(
                    itemCount: widget.cartProducts.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) => CartItemWidget(
                      product: widget.cartProducts[index],
                      cartProducts: widget.cartProducts,
                      onAddToCart: widget.onAddToCart,
                      onRemoveFromBasket: widget.onRemoveFromBasket,
                      onDecreaseAmount: widget.onDecreaseAmount,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              ).paddingSymmetric(horizontal: 24),
            ),
            if (widget.cartProducts.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.themeC.divider,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(24),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.t.cartTotal,
                          style: context.themeC.textStyle.copyWith(
                            color: context.themeC.textSecondaryDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$${totalCartPrice.toStringAsFixed(2)}',
                          style: context.themeC.textStyle.copyWith(
                            color: context.themeC.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ButtonWidget(
                        type: ButtonType.dark,
                        label: context.t.checkout,
                        onTap: () {
                          //
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}
