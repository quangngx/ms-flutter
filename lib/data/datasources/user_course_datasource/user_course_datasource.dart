import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';

abstract class UserCourseDataSource {
  Future<CourseDetailResponse> getCourse(int id);

  Future<UserCourseResponse> getUserCourses();

  Future<CurriculumResponse> getCourseCurriculum(int id);
}
