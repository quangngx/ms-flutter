part of 'quiz_lesson_bloc.dart';

@immutable
abstract class QuizLessonState {}

class InitialQuizLessonState extends QuizLessonState {}

class ErrorQuizLessonErrorState extends QuizLessonState {
  ErrorQuizLessonErrorState(this.message);

  final String? message;
}

class LoadedQuizLessonState extends QuizLessonState {
  LoadedQuizLessonState(this.quizResponse);

  final QuizResponse quizResponse;
}
