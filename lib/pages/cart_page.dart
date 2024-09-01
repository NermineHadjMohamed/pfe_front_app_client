import 'package:client_app/application/state/cart_state.dart';
import 'package:client_app/config.dart';
import 'package:client_app/models/cart.dart';
import 'package:client_app/models/cart_product.dart';
import 'package:client_app/providers.dart';
import 'package:client_app/widgets/widget_cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    print("CART PGE");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      bottomNavigationBar: _checkoutBottomNavbar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: _CartList(ref),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget _builCartItems(List<CartProduct> cartProducts, WidgetRef ref) {
    print("builder");
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: cartProducts.length,
      itemBuilder: (context, index) {
        return CartItemWidget(
          model: cartProducts[index],
          onQuantityUpdate: (CartProduct model, quantity, type) {
            final cartViewModel = ref.read(cartItemsProvider.notifier);

            cartViewModel.updateQuantity(model.product.id, quantity, type);
          },
          onItemRemove: (CartProduct model) {
            final cartViewModel = ref.read(cartItemsProvider.notifier);

            cartViewModel.removeCartItem(model.product.id, model.quantity);
          },
        );
      },
    );
  }

  Widget _CartList(WidgetRef ref) {
    final CartState = ref.watch(cartItemsProvider);

    if (CartState.cartModel == null) {
      return const LinearProgressIndicator();
    }

    if (CartState.cartModel!.products.isEmpty) {
      return const Center(
        child: Text('Cart Empty'),
      );
    }

    return _builCartItems(CartState.cartModel!.products, ref);
  }
}

class _checkoutBottomNavbar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProvider = ref.watch(cartItemsProvider);

    if (cartProvider.cartModel != null) {
      return cartProvider.cartModel!.products.isNotEmpty
          ? Container(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ${Config.currency}${cartProvider.cartModel!.gransTotal.toString()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          "Procced to Checkout",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed("/payments");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox();
    }

    return const SizedBox();
  }
}
