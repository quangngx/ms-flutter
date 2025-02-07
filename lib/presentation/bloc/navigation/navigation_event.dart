part of 'navigation_bloc.dart';

abstract class NavigationEvent {}

class ChangeNavEvent implements NavigationEvent {
  ChangeNavEvent(this.index);

  final int index;
}
