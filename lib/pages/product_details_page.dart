import 'dart:convert';

import 'package:client_app/components/widget_col_exp.dart';
import 'package:client_app/components/widget_custom_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client_app/config.dart';
import 'package:client_app/models/product.dart';
import 'package:client_app/providers.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  String productId = "";
  int quantity = 1;
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantityController.text = quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Details"),
      ),
      body: SingleChildScrollView(
        child: _productDetails(ref),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null && arguments is Map) {
      productId = arguments["productId"];
      print(productId);
    }

    super.didChangeDependencies();
  }

  Widget _productDetails(WidgetRef ref) {
    final details = ref.watch(productDetailsProvider(productId));
    return details.when(
      data: (model) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_productDetailsUI(model!)],
        );
      },
      error: (_, __) => const Center(child: Text("Error")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _productDetailsUI(Product model) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Image.memory(
              base64Decode(model.productImage),
              fit: BoxFit.cover,
            ),
          ),
          Text(
            model.productName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Config.currency}${model.productPrice.toString()}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                  ),
                  onChanged: (value) {
                    int? newQuantity = int.tryParse(value);
                    if (newQuantity != null && newQuantity > 0) {
                      setState(() {
                        quantity = newQuantity;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              CustomStepper(
                lowerLimit: 1,
                upperLimit: 20,
                stepValue: 1,
                iconSize: 20.0,
                value: quantity,
                onChanged: (value) {
                  setState(() {
                    quantity = value["quantity"];
                    quantityController.text = quantity.toString();
                  });
                },
              )
            ],
          ),
          TextButton.icon(
            onPressed: () {
              final cartViewModel = ref.read(cartItemsProvider.notifier);
              cartViewModel.addCartItem(model.id, quantity);
              // Show a SnackBar alerting the user that the product was added to the cart
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Product added to order",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );

              // Delay the navigation until after the SnackBar is shown
              Future.delayed(const Duration(seconds: 2), () {
                // Navigate back to the /products page
                Navigator.pushReplacementNamed(context, "/");
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            icon: const Icon(
              Icons.shopping_basket,
              color: Colors.white,
            ),
            label: const Text(
              "Add to Order",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ColExpand(
            title: "Description",
            content: model.description,
          )
        ],
      ),
    );
  }
}
