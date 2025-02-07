part of 'navigation_bloc.dart';

abstract class NavigationState {}

class ChangedNavigationState implements NavigationState {
  ChangedNavigationState(this.index);

  final int index;
}
