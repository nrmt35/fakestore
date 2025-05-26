import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/resources/resource.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/presentation/wishlist/widget/wishlist_item_widget.dart';
import 'package:fakestore/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WishlistWidget extends StatefulWidget {
  const WishlistWidget({
    required this.favProducts,
    required this.cartProducts,
    required this.onAddToCart,
    required this.onAddToFav,
    super.key,
  });

  final List<Product> favProducts;
  final List<Product> cartProducts;
  final void Function(Product) onAddToCart;
  final void Function(Product) onAddToFav;

  @override
  State<WishlistWidget> createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends State<WishlistWidget> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.t.wishlist,
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
                    itemCount: widget.favProducts.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) => WishlistItemWidget(
                      product: widget.favProducts[index],
                      favProducts: widget.favProducts,
                      cartProducts: widget.cartProducts,
                      onAddToCart: widget.onAddToCart,
                      onAddToFav: widget.onAddToFav,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              ).paddingSymmetric(horizontal: 24),
            ),
          ],
        ),
      );
}
