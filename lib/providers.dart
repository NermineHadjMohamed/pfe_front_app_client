import 'package:client_app/api/api_service.dart';
import 'package:client_app/application/notifier/cart_notifier.dart';
import 'package:client_app/application/notifier/order_notifier.dart';
import 'package:client_app/application/notifier/product_filter_notifier.dart';
import 'package:client_app/application/notifier/products_notifier.dart';
import 'package:client_app/application/state/cart_state.dart';
import 'package:client_app/application/state/order_state.dart';
import 'package:client_app/application/state/product_state.dart';
import 'package:client_app/models/category.dart';
import 'package:client_app/models/pagination.dart';
import 'package:client_app/models/product.dart';
import 'package:client_app/models/product_filter.dart';
import 'package:client_app/pages/product_details_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

final categoriesProvider =
    FutureProvider.family<List<Category>?, PaginationModel>(
  (ref, paginationModel) {
    final apiRepository = ref.watch(apiService);
    return apiRepository.getCategories(
      paginationModel.page,
      paginationModel.pageSize,
    );
  },
);

final homeProductProvider =
    FutureProvider.family<List<Product>?, ProductFilterModel>(
  (ref, productFilterModel) {
    final apiRepository = ref.watch(apiService);
    return apiRepository.getProducts(productFilterModel);
  },
);

final productsFilterProvider =
    StateNotifierProvider<ProductsFilterNotifier, ProductFilterModel>(
  (ref) => ProductsFilterNotifier(),
);

final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) => ProductsNotifier(
    ref.watch(apiService),
    ref.watch(productsFilterProvider),
  ),
);

final productDetailsProvider = FutureProvider.family<Product?, String>(
  (ref, productId) {
    final apiRepository = ref.watch(apiService);
    return apiRepository.getProductDetails(productId);
  },
);

final cartItemsProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(
    ref.watch(apiService),
  ),
);

final OrderProvider =
    StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(
    ref.watch(apiService),
  ),
);