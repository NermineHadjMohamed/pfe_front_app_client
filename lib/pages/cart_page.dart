import 'package:client_app/api/api_service.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      bottomNavigationBar: _CheckoutBottomNavbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _CartList(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(List<CartProduct> cartProducts, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: cartProducts.length,
      itemBuilder: (context, index) {
        return CartItemWidget(
          model: cartProducts[index],
          onQuantityUpdate: (CartProduct model, quantity, type) {
            final cartViewModel = ref.read(cartItemsProvider.notifier);
            cartViewModel.updateQuantity(model.product.id, quantity.toInt(), type);
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
    final cartState = ref.watch(cartItemsProvider);

    if (cartState.cartModel == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cartState.cartModel!.products.isEmpty) {
      return const Center(child: Text('Order Empty'));
    }

    return _buildCartItems(cartState.cartModel!.products, ref);
  }
}

class _CheckoutBottomNavbar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProvider = ref.watch(cartItemsProvider);

    if (cartProvider.cartModel != null &&
        cartProvider.cartModel!.products.isNotEmpty) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ${Config.currency}${cartProvider.cartModel!.grandTotal.toString()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                child: const Text(
                  "Pass Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                onTap: () async {
                  try {
                    // Afficher le spinner de chargement
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    // Appel à l'API pour créer une commande
                    await APIService().createOrder(
                      cartProvider.cartModel!.userId,
                      cartProvider.cartModel!.grandTotal,
                      'created', // Status initial de la commande
                      cartProvider.cartModel!.products.map((item) {
                        return {
                          'product': item.product.id,
                          'quantity': item.quantity.toInt(),
                          'amount': item.product.productPrice,
                        };
                      }).toList(),
                    );

                    // Fermer le spinner de chargement
                    Navigator.of(context).pop();

                    // Naviguer vers la page de succès de commande
                    Navigator.of(context).pushNamed("/order-success");
                  } catch (error) {
                    // Fermer le spinner de chargement
                    Navigator.of(context).pop();

                    // Afficher un message d'erreur en cas d'échec
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Order creation failed: $error")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
