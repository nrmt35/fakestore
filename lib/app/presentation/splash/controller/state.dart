import 'package:fakestore/app/presentation/splash/controller/cubit_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState.initial() = Initial;
}
