import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/presentation/home/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/home/controller/state.dart';
import 'package:fakestore/app/presentation/home/widget/home_widget.dart';
import 'package:fakestore/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({
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

  Widget _buildBody(BuildContext context) => BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return state.maybeWhen(
            loading: () => Center(
              child: CircularProgressIndicator(
                color: context.themeC.buttonBackground,
                strokeCap: StrokeCap.round,
              ),
            ),
            orElse: () => HomeWidget(
              products: cubit.products,
              favProducts: favProducts,
              cartProducts: cartProducts,
              onAddToCart: onAddToCart,
              onAddToFav: onAddToFav,
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) => BlocProvider<HomeCubit>(
        create: (context) => Injector.resolve<HomeCubit>()..init(),
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
