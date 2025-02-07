part of 'user_course_bloc.dart';

@immutable
abstract class UserCourseEvent {}

class LoadUserDetailCourseEvent extends UserCourseEvent {
  LoadUserDetailCourseEvent(this.postsBean);

  final PostsBean postsBean;
}

class CacheCourseEvent extends UserCourseEvent {
  CacheCourseEvent(this.postsBean);

  final PostsBean postsBean;
}
