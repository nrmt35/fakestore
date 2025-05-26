import 'package:dartz/dartz.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/data/datasources/local/local_datasource.dart';
import 'package:fakestore/app/data/datasources/remote/api_datasource.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/domain/repositories/interfaces/product_repository.dart';

const CLASS_TAG = "[AUTH_REPOSITORY]";

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(
    this.apiRemoteDatasource,
    this.localDatasource,
  );

  final ApiRemoteDatasource apiRemoteDatasource;
  final LocalDatasource localDatasource;

  @override
  Future<Either<Failure, List<Product>>> products() async => apiRemoteDatasource.products();

  @override
  Future<Either<Failure, List<Product>>> readProducts() async {
    try {
      final data = await localDatasource.readProducts();
      return Right(data);
    } on Exception catch (_) {
      return const Left(
        CacheFailure('$CLASS_TAG Something went wrong'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Product>>> addProduct(Product product) async {
    try {
      final data = await localDatasource.addProduct(product);
      return Right(data);
    } on Exception catch (_) {
      return const Left(
        CacheFailure('$CLASS_TAG Something went wrong'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Product>>> deleteProduct(Product product) async {
    try {
      final data = await localDatasource.deleteProduct(product);
      return Right(data);
    } on Exception catch (_) {
      return const Left(
        CacheFailure('$CLASS_TAG Something went wrong'),
      );
    }
  }
}
