import 'package:fakestore/app/presentation/wishlist/controller/cubit_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class WishlistState with _$WishlistState {
  const factory WishlistState.initial() = Initial;
}
