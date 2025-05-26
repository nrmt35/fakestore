import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class BottomNavigationState with _$BottomNavigationState {
  const factory BottomNavigationState.initial() = Initial;

  const factory BottomNavigationState.loading() = Loading;

  const factory BottomNavigationState.success() = Success;
}
