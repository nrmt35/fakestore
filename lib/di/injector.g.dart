// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void _configureCore() {}
  @override
  void _configureFeatureModuleFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => ApiRemoteDatasource(c.resolve<RestClient>()))
      ..registerSingleton<UserRepository>((c) => UserRepositoryImpl(
          c.resolve<ApiRemoteDatasource>(), c.resolve<LocalDatasource>()))
      ..registerSingleton<ProductRepository>((c) => ProductRepositoryImpl(
          c.resolve<ApiRemoteDatasource>(), c.resolve<LocalDatasource>()))
      ..registerFactory((c) => Login(c.resolve<UserRepository>()))
      ..registerFactory((c) => ReadToken(c.resolve<UserRepository>()))
      ..registerFactory((c) => PutToken(c.resolve<UserRepository>()))
      ..registerFactory((c) => DeleteToken(c.resolve<UserRepository>()))
      ..registerFactory(
          (c) => InitializeLocalizations(c.resolve<SharedPreferences>()))
      ..registerFactory((c) => GetProducts(c.resolve<ProductRepository>()))
      ..registerFactory((c) => GetLocalProducts(c.resolve<ProductRepository>()))
      ..registerFactory((c) => AddProduct(c.resolve<ProductRepository>()))
      ..registerFactory((c) => DeleteProduct(c.resolve<ProductRepository>()))
      ..registerFactory((c) => SplashCubit(c.resolve<ReadToken>()))
      ..registerFactory((c) => BottomNavigationCubit(
          c.resolve<GetLocalProducts>(),
          c.resolve<AddProduct>(),
          c.resolve<DeleteProduct>()))
      ..registerFactory((c) => HomeCubit(c.resolve<GetProducts>()))
      ..registerFactory((c) => WishlistCubit())
      ..registerFactory((c) => CartCubit())
      ..registerFactory(
          (c) => AuthCubit(c.resolve<Login>(), c.resolve<PutToken>()));
  }
}
