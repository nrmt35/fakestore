import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';
import 'package:fakestore/app/domain/usecases/user/read_token.dart';
import 'package:fakestore/di/injector.dart';
import 'package:logger/logger.dart';

class ApiProviderTokenInterceptor extends Interceptor {
  ApiProviderTokenInterceptor(this.dio) {
    _readToken = Injector.resolve<ReadToken>();
  }

  late ReadToken _readToken;
  LoginResponse? token;
  Dio dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await readToken();
    if (token != null) {
      options.headers.addAll({'Authorization': 'Bearer ${token?.token}'});
    }
    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) =>
      handler.next(response);

  Future<void> readToken() async {
    final Either<Failure, LoginResponse?> failureOrGetAuth = await _readToken.call(NoParams());
    return failureOrGetAuth.fold(
      (failure) {
        Logger().e(failure.message);
        return null;
      },
      (response) => token = response,
    );
  }
}
