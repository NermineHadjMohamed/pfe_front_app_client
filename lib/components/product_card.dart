import 'dart:convert';

import 'package:client_app/config.dart';
import 'package:client_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductCard extends StatelessWidget {
  final Product? model;
  const ProductCard({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        decoration: const BoxDecoration(color: Colors.white),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: model!.calculateDiscount > 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Text(
                        "${model!.calculateDiscount}%OFF",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: SizedBox(
                    child: Image.memory(
                      base64Decode(model!.productImage),
                      fit: BoxFit.cover,
                    ),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      "/product-details",
                      arguments: {'productId': model!.id},

                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 10),
                  child: Text(
                    model!.productName,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Text(
                              "${Config.currency}${model!.productPrice.toString()}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: model!.calculateDiscount > 0
                                    ? Colors.red
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //Text(model!.description)
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onTap: () {},
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
