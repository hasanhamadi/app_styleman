import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'iorder_repository.dart';
import 'order_model.dart';
import 'order_service.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final IOrderRepository repository;
  int currentPage = 1;

  OrderBloc(this.repository) : super(OrderInitial()) {
    on<LoadOrdersEvent>((event, emit) async {
      if (event.isRefresh) currentPage = 1;
      if (state is OrderLoading) return;

      final currentState = state;
      List<OrderModel> oldOrders = [];
      if (currentState is OrderLoaded && !event.isRefresh) {
        oldOrders = currentState.orders;
      }

      emit(OrderLoading());
      try {
        final newOrders = await repository.getOrders(page: currentPage);
        currentPage++;
        emit(OrderLoaded(oldOrders + newOrders, hasReachedMax: newOrders.isEmpty));
      } catch (e) {
        emit(OrderError("خطا در دریافت سفارشات"));
      }
    });
  }
}