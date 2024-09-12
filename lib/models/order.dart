import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  factory Order({
    required String id,
    required String userId,
    required List<Product> products, // Define Product class separately
    required double grandTotal,
    required String orderStatus,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
abstract class Product with _$Product {
  factory Product({
    required String product,
    required double amount,
    required int quantity,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
