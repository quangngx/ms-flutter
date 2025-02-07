import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';

part 'complete_lesson_event.dart';

part 'complete_lesson_state.dart';

class CompleteLessonBloc extends Bloc<CompleteLessonEvent, CompleteLessonState> {
  CompleteLessonBloc() : super(InitialCompleteLessonState()) {
    on<UpdateLessonEvent>((event, emit) async {
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      List<String>? existRecord = preferences.getStringList(PreferencesName.lessonComplete) ?? [];
      List<String>? tempRecord = List.from(existRecord);

      if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
        emit(LoadingCompleteLessonState());

        try {
          await repository.completeLesson(event.courseId, event.lessonId);
          emit(SuccessCompleteLessonState());
        } catch (e, s) {
          logger.e('Error completeLesson', e, s);
          emit(ErrorCompleteLessonState());
        }
      } else {
        if (tempRecord.isNotEmpty) {
          for (var element in tempRecord) {
            if (jsonDecode(element)['added'] == true && jsonDecode(element)['lesson_id'] == event.lessonId) {
              log('Lesson is completed');

              return;
            }
          }

          Map<String, dynamic> recordMap = {
            'course_id': event.courseId,
            'lesson_id': event.lessonId,
            'added': true,
          };

          tempRecord.add(jsonEncode(recordMap));

          preferences.setStringList(PreferencesName.lessonComplete, tempRecord);

          emit(SuccessCompleteLessonState());
        } else {
          Map<String, dynamic> recordMap = {
            'course_id': event.courseId,
            'lesson_id': event.lessonId,
            'added': true,
          };

          tempRecord.add(jsonEncode(recordMap));

          preferences.setStringList(PreferencesName.lessonComplete, tempRecord);

          emit(SuccessCompleteLessonState());
        }
      }
    });
  }

  final LessonRepository repository = LessonRepositoryImpl();
}
