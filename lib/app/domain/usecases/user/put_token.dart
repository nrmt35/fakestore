import 'package:dartz/dartz.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';
import 'package:fakestore/app/domain/repositories/interfaces/user_repository.dart';

const CLASS_TAG = '[PUT_LOGIN_USE_CASE]';

class PutToken implements UseCase<NoParams, LoginResponse> {
  PutToken(this.repository);

  final UserRepository repository;

  @override
  Future<Either<Failure, NoParams>> call(LoginResponse params) async => repository.putLogin(params);
}
