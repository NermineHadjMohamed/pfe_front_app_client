import 'dart:convert';
import 'package:client_app/components/widget_custom_stepper.dart';
import 'package:client_app/config.dart';
import 'package:client_app/models/cart_product.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    Key? key,
    required this.model,
    this.onQuantityUpdate,
    this.onItemRemove,
  }) : super(key: key);

  final CartProduct model;
  final Function? onQuantityUpdate;
  final Function? onItemRemove;

  @override
  Widget build(BuildContext context) {
    // Using an integer value for quantity
    TextEditingController quantityController =
        TextEditingController(text: model.quantity.toString());

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white),
        child: cartItemUI(context, quantityController),
      ),
    );
  }

  Widget cartItemUI(
      BuildContext context, TextEditingController quantityController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
          child: Container(
            width: 48,
            alignment: Alignment.center,
            child: Image.memory(
              base64Decode(model.product.productImage),
              height: 48,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          width: 230,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.product.productName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${Config.currency}${model.product.productPrice.toString()}",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          // Call the update function when the value changes
                          onQuantityUpdate!(model, newQuantity, "update");
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomStepper(
                    lowerLimit: 1,
                    upperLimit: 20,
                    stepValue: 1,
                    iconSize: 15.0,
                    value: model.quantity.toInt(), // Ensure this is an int
                    onChanged: (value) {
                      int newQuantity =
                          value["quantity"].toInt(); // Convert to int
                      quantityController.text = newQuantity.toString();
                      onQuantityUpdate!(model, newQuantity, value["type"]);
                    },
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: GestureDetector(
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () {
                        onItemRemove!(model);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
