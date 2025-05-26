import 'dart:async';

import 'package:fakestore/app/data/models/auth/login_payload/login_payload.dart';
import 'package:fakestore/app/domain/usecases/user/login.dart';
import 'package:fakestore/app/domain/usecases/user/put_token.dart';
import 'package:fakestore/app/presentation/auth/controller/state.dart';
import 'package:fakestore/app/routes/app_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._login,
    this._putLogin,
  ) : super(const Intro());

  final Login _login;
  final PutToken _putLogin;

  bool isLoading = false;

  Future<void> init() async {}

  void onTapBack() {
    emit(Intro());
  }

  void onTapNext() {
    emit(Initial());
  }

  void showLoader() {
    isLoading = true;
    emit(Initial());
    emit(Success());
  }

  void hideLoader() {
    isLoading = false;
    emit(Initial());
    emit(Success());
  }

  Future<void> onTapLogin(String username, String password) async {
    if (isLoading) {
      return;
    }
    showLoader();
    final failureOrLogin = await _login.call(
      LoginPayload(
        username: username,
        password: password,
      ),
    );
    return failureOrLogin.fold(
      (error) {
        Get.snackbar('Attention', error.message);
        hideLoader();
      },
      (response) {
        hideLoader();
        _putLogin(response);
        Get.offAllNamed(Routes.MAIN_SCREEN);
      },
    );
  }
}
