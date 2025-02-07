part of 'text_lesson_bloc.dart';

@immutable
abstract class TextLessonEvent {}

class LoadTextLessonEvent extends TextLessonEvent {
  LoadTextLessonEvent(this.courseId, this.lessonId);

  final int courseId;
  final int lessonId;
}
