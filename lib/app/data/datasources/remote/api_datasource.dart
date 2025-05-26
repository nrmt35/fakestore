import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fakestore/app/core/errors/exceptions.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/data/api/base_api.dart';
import 'package:fakestore/app/data/models/auth/login_payload/login_payload.dart';
import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:logger/logger.dart';

const ERROR_MESSAGE = '[API_REMOTE_DATASOURCE]';
const OK_RESPONSE_CODE = 200;
const CREATED_RESPONSE_CODE = 201;

class ApiRemoteDatasource {
  ApiRemoteDatasource(this.apiClient);

  final RestClient apiClient;

  Future<Either<Failure, LoginResponse>> login(LoginPayload body) async {
    try {
      final response = await apiClient.login(body);
      final statusCode = response.response.statusCode;

      if (statusCode == OK_RESPONSE_CODE || statusCode == CREATED_RESPONSE_CODE) {
        return Right(response.data);
      }
      throw ErrorStatusCodeException(
        statusCode: statusCode ?? 0,
        statusMessage: response.response.statusMessage ?? 'no data',
      );
    } on DioException catch (error) {
      final errorMessage = error.response?.data;
      Logger().e('$ERROR_MESSAGE ${error.type}: ${errorMessage ?? error.message}');

      return Left(Failure('${errorMessage ?? error.message}'));
    } on Exception catch (_) {
      return const Left(Failure('$ERROR_MESSAGE login'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Product>>> products() async {
    try {
      final response = await apiClient.products();
      final statusCode = response.response.statusCode;

      if (statusCode == OK_RESPONSE_CODE || statusCode == CREATED_RESPONSE_CODE) {
        return Right(response.data);
      }
      throw ErrorStatusCodeException(
        statusCode: statusCode ?? 0,
        statusMessage: response.response.statusMessage ?? 'no data',
      );
    } on DioException catch (error) {
      final errorMessage = error.response?.data;
      Logger().e('$ERROR_MESSAGE ${error.type}: ${errorMessage ?? error.message}');

      return Left(Failure('${errorMessage ?? error.message}'));
    } on Exception catch (_) {
      return const Left(Failure('$ERROR_MESSAGE products'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
