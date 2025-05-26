import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/resources/resource.dart';
import 'package:fakestore/app/core/widgets/button_widget.dart';
import 'package:fakestore/app/core/widgets/optimized_image.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({
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
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    final expandedHeight = MediaQuery.of(context).size.height * 0.49;
    final isFavorite = widget.favProducts.any((p) => p.id == widget.product.id);
    final isInCart = widget.cartProducts.any((p) => p.id == widget.product.id);
    Widget appBarBuilder(BuildContext context, BoxConstraints constraints) {
      final FlexibleSpaceBarSettings settings =
          context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
      double height = settings.maxExtent;
      if (constraints.maxHeight > height) {
        height = constraints.maxHeight;
      }

      final background = Positioned(
        left: 0,
        right: 0,
        height: height,
        child: Padding(
          padding: const EdgeInsets.only(
            top: kToolbarHeight,
          ),
          child: OptimizedImage(
            imageUrl: widget.product.image,
            fit: BoxFit.contain,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.5,
          ),
        ),
      );

      return Stack(
        children: [
          background,
        ],
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: expandedHeight,
                  stretch: true,
                  leading: BackButton(
                    color: Colors.black,
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        widget.onAddToFav(widget.product);
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        isFavorite ? R.heartFilledIcon : R.wishlistIcon,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          isFavorite ? context.themeC.red : context.themeC.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                  ],
                  backgroundColor: context.themeC.background,
                  flexibleSpace: LayoutBuilder(builder: appBarBuilder),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      color: context.themeC.background,
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            widget.product.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: context.themeC.textStyle.copyWith(
                              color: context.themeC.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.product.category,
                            style: context.themeC.textStyle.copyWith(
                              color: context.themeC.textSecondaryDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${widget.product.rating.count.toString()} ${context.t.reviews}',
                                style: context.themeC.textStyle.copyWith(
                                  color: context.themeC.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              MediaQuery.paddingOf(context).bottom + 24,
            ),
            color: context.themeC.backgroundPrimary,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.price,
                      style: context.themeC.textStyle.copyWith(
                        color: context.themeC.textSecondaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
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
                    label: isInCart ? context.t.alreadyInCart : context.t.addToCart,
                    onTap: () {
                      widget.onAddToCart(widget.product);
                      setState(() {});
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
}
