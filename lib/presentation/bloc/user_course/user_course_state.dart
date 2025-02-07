part of 'user_course_bloc.dart';

@immutable
abstract class UserCourseState {}

class InitialUserCourseState extends UserCourseState {}

class LoadedUserCourseState extends UserCourseState {
  LoadedUserCourseState({
    this.response,
    this.showCachingProgress,
  });

  final CurriculumResponse? response;
  final bool? showCachingProgress;
}

class ErrorUserCourseState extends UserCourseState {
  ErrorUserCourseState(this.message);

  final String? message;
}
