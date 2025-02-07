part of 'user_courses_bloc.dart';

abstract class UserCoursesEvent {}

class LoadUserCoursesEvent extends UserCoursesEvent {}

class SendCompletedLessonEvent extends UserCoursesEvent {}
