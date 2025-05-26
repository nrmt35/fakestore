import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;

  const factory AuthState.intro() = Intro;

  const factory AuthState.loading() = Loading;

  const factory AuthState.success() = Success;
}
