import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/presentation/wishlist/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/wishlist/controller/state.dart';
import 'package:fakestore/app/presentation/wishlist/widget/wishlist_widget.dart';
import 'package:fakestore/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({
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

  Widget _buildBody(BuildContext context) => BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          final cubit = context.read<WishlistCubit>();
          return state.maybeWhen(
            orElse: () => WishlistWidget(
              favProducts: favProducts,
              cartProducts: cartProducts,
              onAddToCart: onAddToCart,
              onAddToFav: onAddToFav,
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) => BlocProvider<WishlistCubit>(
        create: (context) => Injector.resolve<WishlistCubit>()..init(),
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: context.themeC.background,
            body: _buildBody(context),
          ),
        ),
      );
}
