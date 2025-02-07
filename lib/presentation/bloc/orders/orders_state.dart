part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class InitialOrdersState extends OrdersState {}

class LoadingOrdersState extends OrdersState {}

class LoadingMembershipState extends OrdersState {}

class EmptyOrdersState extends OrdersState {}

class EmptyMembershipsState extends OrdersState {}

class LoadedOrdersState extends OrdersState {
  LoadedOrdersState(this.orders);

  final List<OrderBean?> orders;
}

class LoadedMembershipState extends OrdersState {
  LoadedMembershipState(this.memberships);

  final List<MembershipBean?> memberships;
}

class ErrorOrdersState extends OrdersState {
  ErrorOrdersState(this.message);

  final String? message;
}

class ErrorMembershipState extends OrdersState {
  ErrorMembershipState(this.message);

  final String? message;
}
