import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/presentation/cart/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/cart/controller/state.dart';
import 'package:fakestore/app/presentation/cart/widget/cart_widget.dart';
import 'package:fakestore/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({
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

  Widget _buildBody(BuildContext context) => BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cubit = context.read<CartCubit>();
          return state.maybeWhen(
            orElse: () => CartWidget(
              cartProducts: cartProducts,
              onAddToCart: onAddToCart,
              onRemoveFromBasket: onRemoveFromBasket,
              onDecreaseAmount: onDecreaseAmount,
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) => BlocProvider<CartCubit>(
        create: (context) => Injector.resolve<CartCubit>()..init(),
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
