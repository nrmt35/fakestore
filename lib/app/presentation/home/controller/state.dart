import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial() = Initial;

  const factory HomeState.loading() = Loading;

  const factory HomeState.error() = Error;

  const factory HomeState.success() = Success;
}
