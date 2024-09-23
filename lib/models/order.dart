import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  factory Order({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required List<ProductItem> products, // Update to match the structure of the response
    required double grandTotal,
    required String orderStatus,
    required DateTime createdAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

// This is the item in the `products` list in the API response
@freezed
abstract class ProductItem with _$ProductItem {
  factory ProductItem({
    required Product product,  // Nested product object
    required double amount,
    required int quantity,
  }) = _ProductItem;

  factory ProductItem.fromJson(Map<String, dynamic> json) => _$ProductItemFromJson(json);
}

// This matches the `product` object inside the `ProductItem` in the response
@freezed
abstract class Product with _$Product {
  factory Product({
    @JsonKey(name: '_id') required String id,
    required String product_name,
    required double product_price,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
