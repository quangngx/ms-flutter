import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/cached_course/cached_course.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';

part 'download_course_event.dart';

part 'download_course_state.dart';

class DownloadCourseBloc extends Bloc<DownloadCourseEvent, DownloadCourseState> {
  DownloadCourseBloc() : super(InitialDownloadCourseState()) {
    on<CheckCourseDownloadEvent>((event, emit) {
      // Массив курсов из локального хранилища
      List<String>? coursesOfStorage = preferences.getStringList(PreferencesName.userCoursesStorage);

      // Новый массив для цикла
      List<CachedCourse?> courses = [];

      for (var element in coursesOfStorage ?? []) {
        courses.add(CachedCourse.fromJson(jsonDecode(element)));
      }

      // Проверка есть ли такой курс с таким hash
      List<CachedCourse?> courseIsExist =
          courses.where((element) => element?.postsBean?.hash == event.courseHash).toList();

      if (courseIsExist.isNotEmpty) {
        emit(LoadedDownloadCourseState());
      } else {
        emit(InitialDownloadCourseState());
      }
    });

    on<DownloadEvent>((event, emit) async {
      emit(LoadingDownloadCourseState());

      try {
        List<int> sectionsId = [];

        for (var element in event.curriculumResponse?.materials ?? []) {
          sectionsId.add(element.postId);
        }

        List<LessonResponse> lessonsResponse = await _lessonsRepository.getAllLessons(
          int.parse(event.postsBean.courseId ?? ''),
          sectionsId,
        );

        CachedCourse cachedCourse = CachedCourse(
          id: int.parse(event.postsBean.courseId ?? ''),
          curriculumResponse: event.curriculumResponse,
          lessons: lessonsResponse,
          hash: event.postsBean.hash,
          postsBean: event.postsBean..fromCache = true,
        );

        // ---- Функционал добавления курса в список всех курсов пользователя ---- //

        // Получаем курсы пользователя из локального хранилища
        List<String>? coursesOfStorage = preferences.getStringList(PreferencesName.userCoursesStorage) ?? [];

        // Добавляем объект в массив курсов пользователя
        coursesOfStorage.add(jsonEncode(cachedCourse));

        // Записываем в локальное хранилище
        preferences.setStringList(PreferencesName.userCoursesStorage, coursesOfStorage);

        emit(LoadedDownloadCourseState());
      } catch (e, s) {
        logger.e('Error with download course', e, s);

        emit(ErrorDownloadCourseState(e.toString()));
      }
    });
  }

  final _lessonsRepository = LessonRepositoryImpl();
}
