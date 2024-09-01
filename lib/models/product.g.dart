// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['_id'] as String,
      productName: json['product_name'] as String,
      productPrice: (json['product_price'] as num).toInt(),
      productImage: json['image'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'product_name': instance.productName,
      'product_price': instance.productPrice,
      'image': instance.productImage,
      'description': instance.description,
    };
