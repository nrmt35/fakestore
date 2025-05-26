import 'package:dio/dio.dart' hide Headers;
import 'package:fakestore/app/data/models/auth/login_payload/login_payload.dart';
import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';
import 'package:fakestore/app/data/models/product/product.dart';
import 'package:retrofit/retrofit.dart';

part 'base_api.g.dart';

const String _urlAddress = "https://fakestoreapi.com/";

@RestApi(baseUrl: _urlAddress)
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("auth/login")
  Future<HttpResponse<LoginResponse>> login(
    @Body() LoginPayload body,
  );

  @GET("products")
  Future<HttpResponse<List<Product>>> products();
}
