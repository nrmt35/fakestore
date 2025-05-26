import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/domain/usecases/user/read_token.dart';
import 'package:fakestore/app/presentation/splash/controller/state.dart';
import 'package:fakestore/app/routes/app_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._readLogin) : super(const Initial());

  final ReadToken _readLogin;

  void init() {
    readToken();
  }

  Future<void> readToken() async {
    final failureOrGetAuthToken = await _readLogin.call(NoParams());
    return failureOrGetAuthToken.fold(
      (_) => null,
      (token) async {
        if (token == null) {
          await Get.offAllNamed(Routes.AUTH_SCREEN);
        } else {
          await Get.offAllNamed(Routes.MAIN_SCREEN);
        }
      },
    );
  }
}
