import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fakestore/app/data/api/base_api.dart';
import 'package:fakestore/app/data/datasources/local/local_datasource.dart';
import 'package:fakestore/app/data/datasources/local/object_box/local_datasource_impl.dart';
import 'package:fakestore/app/data/datasources/local/object_box/objectbox.g.dart';
import 'package:fakestore/app/data/datasources/remote/api_datasource.dart';
import 'package:fakestore/app/domain/repositories/interfaces/product_repository.dart';
import 'package:fakestore/app/domain/repositories/interfaces/user_repository.dart';
import 'package:fakestore/app/domain/repositories/product_repository_impl.dart';
import 'package:fakestore/app/domain/repositories/user_repository_impl.dart';
import 'package:fakestore/app/domain/usecases/initialize_localization.dart';
import 'package:fakestore/app/domain/usecases/product/add_product.dart';
import 'package:fakestore/app/domain/usecases/product/delete_product.dart';
import 'package:fakestore/app/domain/usecases/product/get_products.dart';
import 'package:fakestore/app/domain/usecases/product/read_products.dart';
import 'package:fakestore/app/domain/usecases/user/delete_token.dart';
import 'package:fakestore/app/domain/usecases/user/login.dart';
import 'package:fakestore/app/domain/usecases/user/put_token.dart';
import 'package:fakestore/app/domain/usecases/user/read_token.dart';
import 'package:fakestore/app/presentation/auth/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/bottom_navigation/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/cart/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/home/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/splash/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/wishlist/controller/cubit_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injector.g.dart';

const _STORE_NAME = 'main-database';

abstract class Injector {
  static late KiwiContainer container;

  static Future<void> setup() async {
    container = KiwiContainer();
    await _$Injector()._configure();
  }

  static final T Function<T>([String? name]) resolve = container.resolve;

  Future<void> _configure() async {
    await _configureDb();
    _configureCore();
    _configureFeatureModuleFactories();
    _configureApiFeatureModuleInstances();
  }

  void _configureApiFeatureModuleInstances() {
    final dio = Dio(
      BaseOptions(
        contentType: "application/json",
        headers: {"Accept": "application/json"},
      ),
    );
    if (!kIsWeb) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient()
            ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }
    container.registerInstance(
      RestClient(
        dio
          ..interceptors.add(
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseHeader: true,
            ),
          ),
      ),
    );
  }

  static Future<void> _configureDb() async {
    try {
      /// Initialize shared preferences
      final prefs = await SharedPreferences.getInstance();
      container.registerInstance(prefs);
    } on Exception catch (e) {
      Logger().d(e);
    }

    /// Initialize objectbox store
    Store? store;
    final docsDir = await getApplicationDocumentsDirectory();
    final path = p.join(docsDir.path, _STORE_NAME);

    try {
      store = await openStore(directory: path);
    } catch (e) {
      Logger().d(
        '[INIT] Found conflict in DB config, removing old DB and recreate store',
      );

      await Directory(path).delete(recursive: true);
      store = await openStore(directory: path);
    }

    container.registerInstance<LocalDatasource>(LocalDatasourceImpl(store));
  }

  /// Core module
  void _configureCore();

  /// Datasources
  @Register.singleton(ApiRemoteDatasource)

  /// Repositories
  @Register.singleton(UserRepository, from: UserRepositoryImpl)
  @Register.singleton(ProductRepository, from: ProductRepositoryImpl)

  /// Use cases
  @Register.factory(Login)
  @Register.factory(ReadToken)
  @Register.factory(PutToken)
  @Register.factory(DeleteToken)
  @Register.factory(InitializeLocalizations)
  @Register.factory(GetProducts)
  @Register.factory(GetLocalProducts)
  @Register.factory(AddProduct)
  @Register.factory(DeleteProduct)

  /// Cubits
  @Register.factory(SplashCubit)
  @Register.factory(BottomNavigationCubit)
  @Register.factory(HomeCubit)
  @Register.factory(WishlistCubit)
  @Register.factory(CartCubit)
  @Register.factory(AuthCubit)

  /// Other
  void _configureFeatureModuleFactories();
}
