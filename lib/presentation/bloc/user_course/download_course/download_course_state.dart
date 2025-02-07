part of 'download_course_bloc.dart';

abstract class DownloadCourseState {}

class InitialDownloadCourseState extends DownloadCourseState {}

class LoadingDownloadCourseState extends DownloadCourseState {}

class LoadedDownloadCourseState extends DownloadCourseState {}

class ErrorDownloadCourseState extends DownloadCourseState {
  ErrorDownloadCourseState(this.message);

  final String? message;
}
