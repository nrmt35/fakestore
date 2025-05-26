import 'package:dartz/dartz.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/data/datasources/local/local_datasource.dart';
import 'package:fakestore/app/data/datasources/remote/api_datasource.dart';
import 'package:fakestore/app/data/models/auth/login_payload/login_payload.dart';
import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';
import 'package:fakestore/app/domain/repositories/interfaces/user_repository.dart';

const CLASS_TAG = "[AUTH_REPOSITORY]";

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
    this.apiRemoteDatasource,
    this.localDatasource,
  );

  final ApiRemoteDatasource apiRemoteDatasource;
  final LocalDatasource localDatasource;

  @override
  Future<Either<Failure, LoginResponse>> login(LoginPayload body) async =>
      apiRemoteDatasource.login(body);

  @override
  Future<Either<Failure, LoginResponse?>> readLogin() async {
    try {
      final login = await localDatasource.readLogin();

      return Right(login);
    } on Exception catch (_) {
      return const Left(
        CacheFailure('$CLASS_TAG Something went wrong'),
      );
    }
  }

  @override
  Future<Either<Failure, NoParams>> putLogin(LoginResponse body) async {
    try {
      await localDatasource.putLogin(body);

      return Right(NoParams());
    } on Exception catch (_) {
      return const Left(
        CacheFailure('$CLASS_TAG Something went wrong'),
      );
    }
  }

  @override
  Future<Either<Failure, NoParams>> deleteLogin() async {
    try {
      await localDatasource.deleteLogin();

      return Right(NoParams());
    } on Exception catch (_) {
      return const Left(
        CacheFailure('$CLASS_TAG Something went wrong'),
      );
    }
  }
}
