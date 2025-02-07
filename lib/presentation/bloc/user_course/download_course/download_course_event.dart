part of 'download_course_bloc.dart';

abstract class DownloadCourseEvent {}

/// Event для проверки -> скачен ли курс
class CheckCourseDownloadEvent extends DownloadCourseEvent {
  CheckCourseDownloadEvent({required this.courseHash});

  final String? courseHash;
}

class DownloadEvent extends DownloadCourseEvent {
  DownloadEvent({
    required this.curriculumResponse,
    required this.postsBean,
  });

  final CurriculumResponse? curriculumResponse;
  final PostsBean postsBean;
}
