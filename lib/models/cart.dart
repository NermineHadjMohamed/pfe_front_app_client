
import 'package:client_app/models/cart_product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
abstract class Cart with _$Cart {
  factory Cart({
    required String userId,
    required List<CartProduct> products,
    required String cartId,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}

extension CartExt on Cart {
  double get gransTotal {
    return products
        .map((e) => e.product.productPrice)
        .fold(0, (p, c) => p + c);
  }
}
