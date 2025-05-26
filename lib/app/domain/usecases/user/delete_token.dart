import 'package:dartz/dartz.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/domain/repositories/interfaces/user_repository.dart';

const CLASS_TAG = '[DELETE_LOGIN_USE_CASE]';

class DeleteToken implements UseCase<NoParams, NoParams> {
  DeleteToken(this.repository);

  final UserRepository repository;

  @override
  Future<Either<Failure, NoParams>> call(NoParams params) async => repository.deleteLogin();
}
