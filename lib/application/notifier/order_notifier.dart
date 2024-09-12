import 'package:client_app/api/api_service.dart';
import 'package:client_app/application/state/order_state.dart'; // Ensure this is correct
import 'package:client_app/models/order.dart'; // Ensure this is correct
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderNotifier extends StateNotifier<OrderState> {
  final APIService _apiService;

  OrderNotifier(this._apiService) : super(OrderState()); // Use OrderState() instead of const OrderState.initial()

  Future<void> createOrder(
    String userId,
    double grandTotal,
    String orderStatus,
    List<dynamic> products,
  ) async {
    state = state.copyWith(isLoading: true);

    try {
      final orderResponse = await _apiService.createOrder(
        userId,
        grandTotal,
        orderStatus,
        products,
      );

      state = state.copyWith(message: orderResponse["message"]);
      state = state.copyWith(isSuccess: false);

      if (orderResponse["data"] != null) {
        Order order = Order.fromJson(orderResponse["data"]);

        state = state.copyWith(orderResponseModel: order);
        state = state.copyWith(isSuccess: true);
      }
    } catch (e) {
      state = state.copyWith(message: 'Error: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
