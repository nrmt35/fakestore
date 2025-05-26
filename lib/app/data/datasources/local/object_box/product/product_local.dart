import 'package:fakestore/app/data/models/product/product.dart';
import 'package:fakestore/app/data/models/rating/rating.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ProductLocal {
  ProductLocal({
    required this.productId,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rate,
    required this.count,
    this.id = 0,
  });

  factory ProductLocal.fromModel(Product entity) => ProductLocal(
        productId: entity.id,
        title: entity.title,
        price: entity.price,
        description: entity.description,
        category: entity.category,
        image: entity.image,
        rate: entity.rating.rate,
        count: entity.rating.count,
      );

  Product toModel() => Product(
        id: productId,
        title: title,
        price: price,
        description: description,
        category: category,
        image: image,
        rating: Rating(
          rate: rate,
          count: count,
        ),
      );

  int id;
  final int productId;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rate;
  final int count;
}
