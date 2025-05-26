import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';
import 'package:fakestore/app/data/models/product/product.dart';

abstract class LocalDatasource {
  Future<bool> purgeDb();

  Future<LoginResponse?> readLogin();

  Future<void> putLogin(LoginResponse body);

  Future<void> deleteLogin();

  Future<List<Product>> readProducts();

  Future<List<Product>> deleteProduct(Product product);

  Future<List<Product>> addProduct(Product product);
}
