import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/cached_course/cached_course.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:masterstudy_app/data/repository/user_course_repository.dart';

part 'user_courses_event.dart';

part 'user_courses_state.dart';

class UserCoursesBloc extends Bloc<UserCoursesEvent, UserCoursesState> {
  UserCoursesBloc() : super(InitialUserCoursesState()) {
    on<LoadUserCoursesEvent>((event, emit) async {
      emit(InitialUserCoursesState());

      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

      if (!isAuth()) {
        emit(UnauthorizedState());
        return;
      }

      if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
        add(SendCompletedLessonEvent());

        try {
          final response = await _userCourseRepository.getUserCourses(true);

          if (response.posts.isEmpty) {
            emit(EmptyUserCoursesState());
          } else {
            emit(LoadedUserCoursesState(response.posts));
          }
        } catch (e, s) {
          logger.e('Error with load user courses', e, s);
          emit(ErrorUserCoursesState(e.toString()));
        }
      } else {
        try {
          List<CachedCourse?> userCourses = [];

          List<PostsBean?> userPostsBeanCourses = [];

          List<String>? storageOfCourses = preferences.getStringList(PreferencesName.userCoursesStorage);

          if (storageOfCourses != null && storageOfCourses.isNotEmpty) {
            for (var element in storageOfCourses) {
              userCourses.add(
                CachedCourse.fromJson(jsonDecode(element)),
              );
            }

            for (var element in userCourses) {
              userPostsBeanCourses.add(element?.postsBean);
            }

            emit(LoadedUserCoursesState(userPostsBeanCourses));
          } else {
            emit(EmptyUserCoursesState());
          }
        } catch (e, s) {
          logger.e('Error with load storage user courses', e, s);

          emit(ErrorUserCoursesState(e.toString()));
        }
      }
    });

    on<SendCompletedLessonEvent>((event, emit) async {
      List<String> existRecord = preferences.getStringList(PreferencesName.lessonComplete) ?? [];

      if (existRecord.isNotEmpty) {
        try {
          for (var element in existRecord) {
            lessonRepository.completeLesson(
              jsonDecode(element)['course_id'],
              jsonDecode(element)['lesson_id'],
            );
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    });
  }

  final _userCourseRepository = UserCourseRepositoryImpl();
  final lessonRepository = LessonRepositoryImpl();
}
