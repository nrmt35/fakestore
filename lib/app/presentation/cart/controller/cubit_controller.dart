import 'dart:async';

import 'package:fakestore/app/presentation/cart/controller/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const Initial());

  Future<void> init() async {}
}
