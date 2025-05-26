import 'package:dartz/dartz.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/data/models/auth/login_payload/login_payload.dart';
import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';

abstract class UserRepository {
  Future<Either<Failure, LoginResponse>> login(LoginPayload body);

  Future<Either<Failure, LoginResponse?>> readLogin();

  Future<Either<Failure, NoParams>> putLogin(LoginResponse body);

  Future<Either<Failure, NoParams>> deleteLogin();
}
