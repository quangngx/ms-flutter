import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(ChangedNavigationState(0)) {
    on<ChangeNavEvent>((event, emit) async {
      switch (event.index) {
        case 0:
          emit(ChangedNavigationState(0));
          break;
        case 1:
          emit(ChangedNavigationState(1));
          break;
        case 2:
          emit(ChangedNavigationState(2));
          break;
        case 3:
          emit(ChangedNavigationState(3));
          break;
        case 4:
          emit(ChangedNavigationState(4));
          break;

        default:
          emit(ChangedNavigationState(0));
          break;
      }
    });
  }
}
