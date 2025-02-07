import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/datasources/user_course_datasource/user_course_datasource.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';

class UserCourseRemoteDataSource extends UserCourseDataSource {
  final _httpService = HttpService();

  @override
  Future<CourseDetailResponse> getCourse(int id) async {
    try {
      final response = await _httpService.dio.get(
        '/course',
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
        queryParameters: {'id': id},
      );

      return CourseDetailResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserCourseResponse> getUserCourses() async {
    try {
      final response = await _httpService.dio.post(
        '/user_courses?page=0',
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return UserCourseResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CurriculumResponse> getCourseCurriculum(int id) async {
    try {
      final response = await _httpService.dio.post(
        '/course_curriculum',
        data: {'id': id},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return CurriculumResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
