import 'dart:async';

import 'package:fakestore/app/presentation/wishlist/controller/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const Initial());

  Future<void> init() async {}
}
