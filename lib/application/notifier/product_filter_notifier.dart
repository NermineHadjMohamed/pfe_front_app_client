import 'package:client_app/models/pagination.dart';
import 'package:client_app/models/product_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/product_filter.dart';

class ProductsFilterNotifier extends StateNotifier<ProductFilterModel> {
  ProductsFilterNotifier()
      : super(
          ProductFilterModel(
            paginationModel: PaginationModel(page: 0, pageSize: 1),
          ),
        );
  void setProductFilter(ProductFilterModel model) {
    state = model;
  }
}
