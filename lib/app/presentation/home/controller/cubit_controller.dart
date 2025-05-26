import 'dart:async';

import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/domain/usecases/product/get_products.dart';
import 'package:fakestore/app/presentation/home/controller/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._getProducts,
  ) : super(const Loading());

  final GetProducts _getProducts;

  List<Product> products = [];

  void init() {
    getProducts();
  }

  Future<void> getProducts() async {
    final failureOrGetProducts = await _getProducts.call(NoParams());
    return failureOrGetProducts.fold(
      (error) {
        Get.snackbar('Attention', error.message);
        emit(Error());
      },
      (response) {
        products = response;
        emit(Success());
      },
    );
  }
}
