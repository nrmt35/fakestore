import 'package:dartz/dartz.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/data/models/auth/login_payload/login_payload.dart';
import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';
import 'package:fakestore/app/domain/repositories/interfaces/user_repository.dart';

const CLASS_TAG = '[LOGIN_USE_CASE]';

class Login implements UseCase<LoginResponse, LoginPayload> {
  Login(this.repository);

  final UserRepository repository;

  @override
  Future<Either<Failure, LoginResponse>> call(LoginPayload body) async => repository.login(body);
}
