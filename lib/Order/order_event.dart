part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}
class LoadOrdersEvent extends OrderEvent { final bool isRefresh; LoadOrdersEvent({this.isRefresh = false}); }
