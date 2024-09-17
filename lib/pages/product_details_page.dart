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
          //const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomStepper(
                lowerLimit: 1,
                upperLimit: 20,
                stepValue: 1,
                iconSize: 20.0,
                value: quantity,
                onChanged: (value) {
                  setState(() {
                    quantity = value["quantity"];
                  });
                },
              )
            ],
          ),
          TextButton.icon(
            onPressed: () {
              final cartViewModel = ref.read(cartItemsProvider.notifier);
              cartViewModel.addCartItem(model.id, quantity);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            icon: const Icon(
              Icons.shopping_basket,
              color: Colors.white,
            ),
            label: const Text(
              "Add to Cart",
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
