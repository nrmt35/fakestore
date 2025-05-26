import 'package:fakestore/app/presentation/cart/controller/cubit_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class CartState with _$CartState {
  const factory CartState.initial() = Initial;
}
