import 'package:client_app/components/product_card.dart';
import 'package:client_app/models/category.dart';
import 'package:client_app/models/pagination.dart';
import 'package:client_app/models/product.dart';
import 'package:client_app/models/product_filter.dart';
import 'package:client_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeProductsWidget extends ConsumerWidget {
  const HomeProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product> list = List<Product>.empty(growable: true);

    return Container(
      color: const Color(0xffF4F7FA),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 15),
                child: Text(
                  "Products",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: _productsList(ref),
          )
        ],
      ),
    );
  }

  Widget _productsList(WidgetRef ref) {
    final products = ref.watch(
      homeProductProvider(
        ProductFilterModel(
          paginationModel: PaginationModel(page: 1, pageSize: 10),
        ),
      ),
    );

    return products.when(
      data: (list) {
        // Vérifier si la liste est null ou vide
        if (list == null || list.isEmpty) {
          return Center(
              child: Text(
                  "No products available")); // Gestion des cas où la liste est vide
        }

        return _buildProductList(list); // Pas besoin du !
      },
      error: (_, __) {
        return Center(
            child:
                Text("ERROR")); // Assurez-vous de retourner un Widget ici aussi
      },
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return Container(
      height: 200,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          var data = products[index];
          return GestureDetector(
            onTap: () {},
            child: ProductCard(
              model: data,
            ),
          );
        },
      ),
    );
  }
}
