import 'package:client_app/config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'product.freezed.dart';
part 'product.g.dart';

List<Product> productsFromJson(dynamic str) => List<Product>.from(
      (str).map(
        (x) => Product.fromJson(x),
      ),
    );

@freezed
abstract class Product with _$Product {
  factory Product({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'product_price') required int productPrice,
    @JsonKey(name : 'image') required String productImage,
    @JsonKey(name : 'description') required String? description,
  }) = _Product;
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

extension ProductExt on Product {
  String get fullImagePath => Config.imageURL + productImage;

  int get calculateDiscount {
    return productPrice;
  }
}
