// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      orderStatus: json['orderStatus'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'products': instance.products,
      'grandTotal': instance.grandTotal,
      'orderStatus': instance.orderStatus,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$ProductItemImpl _$$ProductItemImplFromJson(Map<String, dynamic> json) =>
    _$ProductItemImpl(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductItemImplToJson(_$ProductItemImpl instance) =>
    <String, dynamic>{
      'product': instance.product,
      'amount': instance.amount,
      'quantity': instance.quantity,
    };

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['_id'] as String,
      product_name: json['product_name'] as String,
      product_price: (json['product_price'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'product_name': instance.product_name,
      'product_price': instance.product_price,
    };
