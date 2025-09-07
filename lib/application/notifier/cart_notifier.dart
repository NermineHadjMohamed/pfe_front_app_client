import 'package:client_app/api/api_service.dart';
import 'package:client_app/application/state/cart_state.dart';
import 'package:client_app/models/cart_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<CartState> {
  final APIService _apiService;

  CartNotifier(this._apiService) : super(const CartState()) {
    getCartItems();
  }

  Future<void> getCartItems() async {
    state = state.copyWith(isLoading: true);

    final cartData = await _apiService.getCart();

    state = state.copyWith(cartModel: cartData);
    state = state.copyWith(isLoading: false);
  }

  Future<void> addCartItem(productId, quantity) async {
    await _apiService.addCartItem(productId, quantity);

    await getCartItems();
  }

  Future<void> removeCartItem(productId, quantity) async {
    await _apiService.removeCartItem(productId, quantity);
    getCartItems();

  }

  Future<void> updateQuantity(productId, quantity, type) async {
    var cartItem = state.cartModel!.products
        .firstWhere((element) => element.product.id == productId);

    var updatedItems = state.cartModel!;

    if (type == "-") {
      await _apiService.removeCartItem(productId, 1);

      if (cartItem.quantity > 1) {
        CartProduct cartProduct = CartProduct(
          quantity: cartItem.quantity - 1,
          product: cartItem.product,
        );

        updatedItems.products.remove(cartItem);
        updatedItems.products.add(cartProduct);
      } else {
        updatedItems.products.remove(cartItem);
      }
    } else {
      await _apiService.addCartItem(productId, 1);

      CartProduct cartProduct = CartProduct(
        quantity: cartItem.quantity + 1,
        product: cartItem.product,
      );

      updatedItems.products.remove(cartItem);
      updatedItems.products.add(cartProduct);
    }

    state = state.copyWith(cartModel: updatedItems);
  }
}
