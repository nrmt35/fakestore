import 'package:dartz/dartz.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/data/models/product/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> products();

  Future<Either<Failure, List<Product>>> addProduct(Product product);

  Future<Either<Failure, List<Product>>> deleteProduct(Product product);

  Future<Either<Failure, List<Product>>> readProducts();
}
