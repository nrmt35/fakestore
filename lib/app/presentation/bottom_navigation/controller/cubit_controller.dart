import 'dart:async';

import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/domain/usecases/product/add_product.dart';
import 'package:fakestore/app/domain/usecases/product/delete_product.dart';
import 'package:fakestore/app/domain/usecases/product/read_products.dart';
import 'package:fakestore/app/presentation/bottom_navigation/controller/state.dart';
import 'package:fakestore/app/presentation/cart/view/cart_page.dart';
import 'package:fakestore/app/presentation/home/view/home_page.dart';
import 'package:fakestore/app/presentation/wishlist/view/wishlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit(
    this._getLocalProducts,
    this._addProduct,
    this._deleteProduct,
  ) : super(const Loading());

  final GetLocalProducts _getLocalProducts;
  final AddProduct _addProduct;
  final DeleteProduct _deleteProduct;

  List<Product> favProducts = [];
  List<Product> cartProducts = [];

  void addToCart(Product product) {
    final index = cartProducts.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      cartProducts.add(product.copyWith(quantity: 1));
    } else {
      final existing = cartProducts[index];
      cartProducts[index] = existing.copyWith(quantity: existing.quantity + 1);
    }
    setPages();
  }

  void decreaseFromCart(Product product) {
    final index = cartProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      final existing = cartProducts[index];
      final newQuantity = existing.quantity - 1;

      if (newQuantity <= 0) {
        cartProducts.removeAt(index);
      } else {
        cartProducts[index] = existing.copyWith(quantity: newQuantity);
      }
      setPages();
    }
  }

  void removeFromCart(Product product) {
    cartProducts.removeWhere((p) => p.id == product.id);
    setPages();
  }

  void onAddToFav(Product product) {
    final isFavorite = favProducts.any((p) => p.id == product.id);
    if (isFavorite) {
      _deleteProduct(product);
      favProducts.removeWhere((p) => p.id == product.id);
    } else {
      _addProduct(product);
      favProducts.add(product);
    }
    setPages();
  }

  List<Widget> pages = [];

  void setPages() {
    pages = [
      HomePage(
        favProducts: favProducts,
        cartProducts: cartProducts,
        onAddToCart: addToCart,
        onAddToFav: onAddToFav,
      ),
      WishlistPage(
        favProducts: favProducts,
        cartProducts: cartProducts,
        onAddToCart: addToCart,
        onAddToFav: onAddToFav,
      ),
      CartPage(
        cartProducts: cartProducts,
        onAddToCart: addToCart,
        onRemoveFromBasket: removeFromCart,
        onDecreaseAmount: decreaseFromCart,
      ),
    ];
    emit(Success());
    emit(Initial());
  }

  Future<void> init() async {
    await getLocalProducts();
    setPages();
  }

  Future<void> getLocalProducts() async {
    final failureOrGetProducts = await _getLocalProducts.call(NoParams());
    return failureOrGetProducts.fold(
      (error) {
        Get.snackbar('Attention', error.message);
      },
      (response) {
        favProducts = response;
        emit(Success());
      },
    );
  }
}
