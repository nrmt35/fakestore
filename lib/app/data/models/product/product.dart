import 'package:fakestore/app/data/models/rating/rating.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  factory Product({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    required Rating rating,
    @JsonKey(defaultValue: 1) @Default(1) int quantity,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
