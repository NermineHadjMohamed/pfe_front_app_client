import 'package:client_app/models/order.dart'; // Adjust import if necessary
import 'package:client_app/models/order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_state.freezed.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState({
    Order? orderResponseModel, // Use Order instead of OrderPayment
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default("") String message,
  }) = _OrderState;
}
