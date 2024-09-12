import 'package:client_app/components/product_card.dart';
import 'package:client_app/models/category.dart';
import 'package:client_app/models/product.dart';
import 'package:client_app/widgets/widget_home_categories.dart';
import 'package:client_app/widgets/widget_home_products.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  /*State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {*/
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            //const HomeCategoriesWidget(),
            const HomeProductsWidget(),
            //ProductCard(
            //ProductCard(
            //model: model,
            //)
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}