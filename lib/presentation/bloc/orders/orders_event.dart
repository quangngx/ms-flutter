part of 'orders_bloc.dart';

abstract class OrdersEvent {}

class LoadOrdersEvent extends OrdersEvent {}

class LoadMembershipEvent extends OrdersEvent {}
