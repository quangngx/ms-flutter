import 'dart:convert';
import 'dart:developer';

import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/datasources/lesson_datasource.dart';
import 'package:masterstudy_app/data/models/cached_course/cached_course.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/data/models/quiz/quiz_response.dart';
import 'package:path_provider/path_provider.dart';

abstract class LessonRepository {
  Future<LessonResponse> getLesson(int courseId, int lessonId);

  Future<QuizResponse> getQuiz(int courseId, int lessonId);

  Future completeLesson(int courseId, int lessonId);

  Future<List<LessonResponse>> getAllLessons(int courseId, List<int?> lessonIds);
}

class LessonRepositoryImpl extends LessonRepository {
  final LessonDataSource _lessonDataSource = LessonRemoteDataSource();

  @override
  Future<LessonResponse> getLesson(int courseId, int lessonId) async {
    LessonResponse? response;

    List<String>? coursesOfStorage = preferences.getStringList(PreferencesName.userCoursesStorage);

    List<CachedCourse> courses = [];

    for (var element in coursesOfStorage ?? []) {
      courses.add(CachedCourse.fromJson(jsonDecode(element)));
    }

    List<CachedCourse> existCourse = courses.where((element) => element.id == courseId).toList();

    try {
      response = await _lessonDataSource.getLesson(courseId, lessonId)
        ..id = courseId;
    } catch (e) {
      if (existCourse.isNotEmpty) {
        if (existCourse.first.lessons.indexWhere((element) => element?.id == lessonId) != -1) {
          response = existCourse.first.lessons.firstWhere((element) => element?.id == lessonId);
        } else {
          return Future.error(e);
        }
      } else {
        return Future.error(e);
      }
    }
    return response!;
  }

  @override
  Future completeLesson(int courseId, int lessonId) async {
    await _lessonDataSource.completeLesson(courseId, lessonId);
    return;
  }

  @override
  Future<QuizResponse> getQuiz(int courseId, int lessonId) async {
    return await _lessonDataSource.getQuiz(courseId, lessonId);
  }

  @override
  Future<List<LessonResponse>> getAllLessons(int courseId, List<dynamic> lessonIds) async {
    List<LessonResponse> lessons = [];

    var lessonFutures = lessonIds.map((element) async {
      try {
        var response = await _lessonDataSource.getLesson(courseId, element);
        return response
          ..id = element
          ..fromCache = true;
      } catch (e) {
        rethrow;
      }
    });

    var loadedLessons = await Future.wait(lessonFutures);

    lessons.addAll(loadedLessons.whereType<LessonResponse>());

    for (var element in lessons) {
      if (element.type == 'video' && element.videoType == VideoTypeCode.html) {
        var directory = await getApplicationDocumentsDirectory();
        String filePath = '${directory.path}/${element.video}';
        try {
          await HttpService().dio.download(
            element.video ?? '',
            filePath,
            onReceiveProgress: (rec, total) {
              log('Rec: $rec, Total:$total');
            },
          );

          element.video = filePath;
        } catch (e) {
          throw Exception(e.toString());
        }
      }
    }

    // TODO: Check func
    // for (var lesson in lessons) {
    //   await _processLesson(lesson);
    // }

    return lessons;
  }
}
