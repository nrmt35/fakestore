import 'package:dartz/dartz.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/domain/repositories/interfaces/product_repository.dart';

const CLASS_TAG = '[LOGIN_USE_CASE]';

class GetProducts implements UseCase<List<Product>, NoParams> {
  GetProducts(this.repository);

  final ProductRepository repository;

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async => repository.products();
}
