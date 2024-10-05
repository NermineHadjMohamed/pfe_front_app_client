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
            cartViewModel.updateQuantity(
                model.product.id, quantity.toInt(), type);
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
                  // Show confirmation dialog before creating the order
                  final bool confirm = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Order'),
                        content: const Text(
                            'Are you sure you want to pass this order?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // Return false if canceled
                            },
                          ),
                          TextButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // Return true if confirmed
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // If the user confirms, proceed to create the order
                  if (confirm) {
                    try {
                      // Show loading spinner
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      // API call to create order
                      await APIService().createOrder(
                        cartProvider.cartModel!.userId,
                        cartProvider.cartModel!.grandTotal,
                        'created', // Initial status of the order
                        cartProvider.cartModel!.products.map((item) {
                          return {
                            'product': item.product.id,
                            'quantity': item.quantity.toInt(),
                            'amount': item.product.productPrice,
                          };
                        }).toList(),
                      );

                      // Hide loading spinner
                      Navigator.of(context).pop();

                      // Navigate to success page
                      Navigator.of(context).pushNamed("/order-success");
                    } catch (error) {
                      // Hide loading spinner
                      Navigator.of(context).pop();

                      // Show error message in case of failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Order creation failed: $error")),
                      );
                    }
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
