import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/orders/orders_response.dart';
import 'package:masterstudy_app/data/repository/purchase_repository.dart';
import 'package:meta/meta.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(InitialOrdersState()) {
    on<LoadOrdersEvent>((event, emit) async {
      emit(LoadingOrdersState());
      try {
        final response = await _purchaseRepository.getOrders();

        if (response.posts.isEmpty) {
          emit(EmptyOrdersState());
        } else {
          emit(LoadedOrdersState(response.posts));
        }
      } catch (e, s) {
        logger.e('Error getOrders - bloc', e, s);
        emit(ErrorOrdersState(e.toString()));
      }
    });

    on<LoadMembershipEvent>((event, emit) async {
      emit(LoadingMembershipState());
      try {
        final response = await _purchaseRepository.getOrders();

        if (response.memberships.isEmpty) {
          emit(EmptyMembershipsState());
        } else {
          emit(LoadedMembershipState(response.memberships));
        }
      } catch (e, s) {
        logger.e('Error getOrders - bloc', e, s);
        emit(ErrorMembershipState(e.toString()));
      }
    });
  }

  final _purchaseRepository = PurchaseRepositoryImpl();
}
