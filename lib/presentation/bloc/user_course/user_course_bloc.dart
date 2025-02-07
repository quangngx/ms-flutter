import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/cached_course/cached_course.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/data/repository/user_course_repository.dart';
import 'package:meta/meta.dart';

part 'user_course_event.dart';

part 'user_course_state.dart';

class UserCourseBloc extends Bloc<UserCourseEvent, UserCourseState> {
  UserCourseBloc() : super(InitialUserCourseState()) {
    on<LoadUserDetailCourseEvent>((event, emit) async {
      int courseId = int.parse(event.postsBean.courseId!);

      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
        try {
          final response = await _repository.getCourseCurriculum(courseId);

          emit(
            LoadedUserCourseState(
              response: response,
              showCachingProgress: false,
            ),
          );
        } catch (e, s) {
          logger.e('Error during with userCourseBloc', e, s);

          emit(ErrorUserCourseState(e.toString()));
        }
      } else {
        try {
          // Массив курсов из локального хранилища
          List<String>? coursesOfStorage = preferences.getStringList(PreferencesName.userCoursesStorage);

          List<CachedCourse> courses = [];

          for (var element in coursesOfStorage ?? []) {
            courses.add(CachedCourse.fromJson(jsonDecode(element)));
          }

          List<CachedCourse> existCourse = courses.where((element) => element.id == courseId).toList();

          if (existCourse.isNotEmpty) {
            emit(
              LoadedUserCourseState(
                response: existCourse.first.curriculumResponse,
                showCachingProgress: true,
              ),
            );
          }
        } catch (e, s) {
          logger.e('Error during with offline userCourseBloc', e, s);

          emit(ErrorUserCourseState(e.toString()));
        }
      }
    });
  }

  final UserCourseRepository _repository = UserCourseRepositoryImpl();
}
