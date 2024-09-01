// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderPaymentImpl _$$OrderPaymentImplFromJson(Map<String, dynamic> json) =>
    _$OrderPaymentImpl(
      stripeCustomerID: json['stripeCustomerID'] as String,
      cardId: json['cardId'] as String,
      paymentIntentId: json['paymentIntentId'] as String,
      orderId: json['orderId'] as String,
      client_secret: json['client_secret'] as String,
    );

Map<String, dynamic> _$$OrderPaymentImplToJson(_$OrderPaymentImpl instance) =>
    <String, dynamic>{
      'stripeCustomerID': instance.stripeCustomerID,
      'cardId': instance.cardId,
      'paymentIntentId': instance.paymentIntentId,
      'orderId': instance.orderId,
      'client_secret': instance.client_secret,
    };
