import 'package:client_app/application/state/product_state.dart';
import 'package:client_app/components/product_card.dart';
import 'package:client_app/models/pagination.dart';
import 'package:client_app/models/product_filter.dart';
import 'package:client_app/models/product_sort.dart';
import 'package:client_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String? categoryId;
  String? categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal, 
      ),
      body: Container(
        color: Colors.white, 
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _ProductFilters(
              categoryId: categoryId,
              categoryName: categoryName,
            ),
            Expanded(
              child: _ProductList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final Map? arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (arguments != null) {
      categoryName = arguments['categoryName'];
      categoryId = arguments['categoryId'];
    }
    super.didChangeDependencies();
  }
}

class _ProductFilters extends ConsumerWidget {
  final _sortByOptions = [
    ProductSortModel(value: "createdAt", label: "Latest"),
    ProductSortModel(value: "productPrice", label: "Price: High to Low"),
    ProductSortModel(value: "productPrice", label: "Price: Low to High"),
  ];

  _ProductFilters({
    Key? key,
    this.categoryName,
    this.categoryId,
  });

  final String? categoryName;
  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterProvider = ref.watch(productsFilterProvider);

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.teal[100], 
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              categoryName ?? "All Products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          PopupMenuButton(
            onSelected: (sortBy) {
              ProductFilterModel filterModel = ProductFilterModel(
                  paginationModel: PaginationModel(page: 0, pageSize: 10),
                  categoryId: filterProvider.categoryId,
                  sortBy: sortBy.toString());

              ref.read(productsFilterProvider.notifier).setProductFilter(filterModel);
              ref.read(productsNotifierProvider.notifier).getProducts();
            },
            initialValue: filterProvider.sortBy,
            itemBuilder: (BuildContext context) {
              return _sortByOptions.map((item) {
                return PopupMenuItem(
                  value: item.value,
                  child: Text(item.label!),
                );
              }).toList();
            },
            icon: Icon(Icons.filter_list, color: Colors.teal),
          ),
        ],
      ),
    );
  }
}

class _ProductList extends ConsumerWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsNotifierProvider);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        final productsViewModel = ref.read(productsNotifierProvider.notifier);
        if (productsState.hasNext) {
          productsViewModel.getProducts();
        }
      }
    });

    if (productsState.products.isEmpty) {
      if (!productsState.hasNext && !productsState.isLoading) {
        return const Center(
          child: Text("No Products Available"),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(productsNotifierProvider.notifier).refreshProducts();
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        controller: _scrollController,
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            model: productsState.products[index],
          );
        },
      ),
    );
  }
}
