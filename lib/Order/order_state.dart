part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}
class OrderLoaded extends OrderState {
  final List<OrderModel> orders;
  final bool hasReachedMax;
  OrderLoaded(this.orders, {this.hasReachedMax = false});
}
class OrderError extends OrderState { final String message; OrderError(this.message); }
