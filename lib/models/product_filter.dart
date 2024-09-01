import 'package:client_app/models/pagination.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_filter.freezed.dart';

@freezed
abstract class ProductFilterModel with _$ProductFilterModel {
  factory ProductFilterModel({
    required PaginationModel paginationModel,
    String? categoryId,
    String? sortBy,
  }) = _ProductFilterModel;

}