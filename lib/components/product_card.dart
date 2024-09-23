import 'dart:convert';
import 'package:client_app/config.dart';
import 'package:client_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product? model;
  const ProductCard({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)), // Rounded top corners
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Image.memory(
                      base64Decode(model!.productImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    "/product-details",
                    arguments: {'productId': model!.id},
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model!.productName,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price: ${Config.currency}${model!.productPrice.toString()}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal, // Changed color to match the theme
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
