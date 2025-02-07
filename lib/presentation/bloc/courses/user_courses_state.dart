part of 'user_courses_bloc.dart';

abstract class UserCoursesState {
  const UserCoursesState();
}

class InitialUserCoursesState extends UserCoursesState {}

class EmptyUserCoursesState extends UserCoursesState {}

class ErrorUserCoursesState extends UserCoursesState {
  ErrorUserCoursesState(this.message);

  final String? message;
}

class LoadedUserCoursesState extends UserCoursesState {
  LoadedUserCoursesState(this.courses);

  final List<PostsBean?> courses;
}

class EmptyCacheCoursesState extends UserCoursesState {}

class UnauthorizedState extends UserCoursesState {}
