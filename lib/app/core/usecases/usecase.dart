import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fakestore/app/core/errors/failure.dart';

// ignore: one_member_abstracts
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// ignore: one_member_abstracts
abstract class UseCaseDynamicFailure<Type, Params> {
  Future<Either<dynamic, Type>> call(Params params);
}

// ignore: one_member_abstracts
abstract class UseCaseStream<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
