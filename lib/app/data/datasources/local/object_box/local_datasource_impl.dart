import 'dart:async';

import 'package:fakestore/app/core/errors/exceptions.dart';
import 'package:fakestore/app/data/datasources/local/local_datasource.dart';
import 'package:fakestore/app/data/datasources/local/object_box/login/login_local.dart';
import 'package:fakestore/app/data/datasources/local/object_box/objectbox.g.dart';
import 'package:fakestore/app/data/datasources/local/object_box/product/product_local.dart';
import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:logger/logger.dart';

const String CLASS_TAG = '[LOCAL DATASOURCE]';

class LocalDatasourceImpl with DbUtils implements LocalDatasource {
  LocalDatasourceImpl(Store store) {
    _store = store;
  }

  @override
  Future<bool> purgeDb() async => true;

  @override
  Future<LoginResponse?> readLogin() async {
    final locals = getAll<LoginLocal>();
    if (locals.isNotEmpty) {
      return locals.first.toModel();
    }
    return null;
  }

  @override
  Future<void> putLogin(LoginResponse body) async {
    final local = LoginLocal.fromModel(body);
    put(local);
  }

  @override
  Future<void> deleteLogin() async {
    deleteAll<LoginLocal>();
  }

  @override
  Future<List<Product>> readProducts() async {
    final locals = getAll<ProductLocal>().map((product) => product.toModel()).toList();
    return locals;
  }

  @override
  Future<List<Product>> addProduct(Product product) async {
    final local = ProductLocal.fromModel(product);
    put(local);
    final locals = getAll<ProductLocal>().map((product) => product.toModel()).toList();
    return locals;
  }

  @override
  Future<List<Product>> deleteProduct(Product product) async {
    final _locals = getAll<ProductLocal>();
    final local = _locals.firstWhere((p) => p.productId == product.id);
    deleteById<ProductLocal>(local.id);
    final locals = getAll<ProductLocal>().map((product) => product.toModel()).toList();
    return locals;
  }
}

typedef DbOperation<T, E> = T Function(Box<E> box);
typedef OnErrorDbOperation<T> = T Function(dynamic error);

mixin DbUtils {
  late final Store _store;

  List<T> getAll<T>() => execute<List<T>, T>(
        (box) => box.getAll(),
        (e) => GetDataException<T>(error: e),
      );

  T? getById<T>(int id) => execute<T?, T>(
        (box) => box.get(id),
        (e) => GetDataException<T>(error: e),
      );

  void put<T>(T model) => execute<void, T>(
        (box) => box.put(model),
        (e) => PutDataException<T>(error: e),
      );

  void putAll<T>(Iterable<T> models) => execute<void, T>(
        (box) => box.putMany(models.toList()),
        (e) => PutDataException<T>(error: e),
      );

  void deleteById<T>(int id) => execute<void, T>(
        (box) => box.remove(id),
        (e) => DeleteDataException<T>(error: e),
      );

  void deleteAll<T>() => execute<void, T>(
        (box) => box.removeAll(),
        (e) => DeleteDataException<T>(error: e),
      );

  T execute<T, E>(
    DbOperation<T, E> operation, [
    OnErrorDbOperation? onError,
  ]) {
    try {
      final box = _store.box<E>();
      return operation(box);
    } catch (e) {
      Logger().e('$CLASS_TAG Error: $e');
      final onErrorResult =
          onError?.call(e) ?? CacheException<T>(message: 'Cannot execute operation', error: e);
      throw onErrorResult;
    }
  }
}
