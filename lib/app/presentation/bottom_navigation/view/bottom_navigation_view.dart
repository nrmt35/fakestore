import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/resources/resource.dart';
import 'package:fakestore/app/core/widgets/bottom_navigation_bar.dart';
import 'package:fakestore/app/presentation/bottom_navigation/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/bottom_navigation/controller/state.dart';
import 'package:fakestore/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TabItem {
  home,
  wishlist,
  cart;

  static const TabItem main = TabItem.home;

  String get icon => switch (this) {
        TabItem.home => R.homeIcon,
        TabItem.wishlist => R.wishlistIcon,
        TabItem.cart => R.cartIcon,
      };
}

class BottomNavigationPage extends StatelessWidget {
  const BottomNavigationPage({super.key});

  Widget _buildBody(BuildContext context) =>
      BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
        builder: (context, state) {
          final cubit = context.read<BottomNavigationCubit>();
          return state.maybeWhen(
            loading: () => Center(
              child: CircularProgressIndicator(
                color: context.themeC.buttonBackground,
                strokeCap: StrokeCap.round,
              ),
            ),
            orElse: () => CustomBottomNavigationBar(cubit.pages),
          );
        },
      );

  @override
  Widget build(BuildContext context) => BlocProvider<BottomNavigationCubit>(
        create: (context) => Injector.resolve<BottomNavigationCubit>()..init(),
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
