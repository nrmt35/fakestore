import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/resources/resource.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/presentation/home/widget/product_widget.dart';
import 'package:fakestore/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    required this.products,
    required this.favProducts,
    required this.cartProducts,
    required this.onAddToCart,
    required this.onAddToFav,
    super.key,
  });

  final List<Product> products;
  final List<Product> favProducts;
  final List<Product> cartProducts;
  final void Function(Product) onAddToCart;
  final void Function(Product) onAddToFav;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${context.t.welcome}, Username',
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
                  SliverToBoxAdapter(
                    child: Text(
                      context.t.appName,
                      style: context.themeC.textStyle.copyWith(
                        color: context.themeC.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                  SliverList.separated(
                    itemCount: widget.products.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) => ProductWidget(
                      product: widget.products[index],
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
