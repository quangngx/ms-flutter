import 'package:masterstudy_app/core/cache/course_curriculum_local.dart';
import 'package:masterstudy_app/core/cache/progress_course_local.dart';
import 'package:masterstudy_app/data/datasources/user_course_datasource/user_course_remote_datasource.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';

abstract class UserCourseRepository {
  Future<UserCourseResponse> getUserCourses(bool isConnected);

  Future<CurriculumResponse> getCourseCurriculum(int id);

  Future<CourseDetailResponse> getCourse(int courseId);

  void saveLocalUserCourses(UserCourseResponse userCourseResponse);

  Future<List<UserCourseResponse>> getUserCoursesLocal();

  void saveLocalCurriculum(CurriculumResponse curriculumResponse, int id);

  Future<List<CurriculumResponse>> getCurriculumLocal(int id);
}

class UserCourseRepositoryImpl extends UserCourseRepository {
  final _userCourseRemoteDataSource = UserCourseRemoteDataSource();
  final _progressCoursesLocalStorage = ProgressCoursesLocalStorage();
  final _curriculumLocalStorage = CurriculumLocalStorage();

  @override
  Future<UserCourseResponse> getUserCourses(bool isConnected) async {
    return await _userCourseRemoteDataSource.getUserCourses();
  }

  @override
  Future<CurriculumResponse> getCourseCurriculum(int id) async =>
      await _userCourseRemoteDataSource.getCourseCurriculum(id);

  @override
  Future<CourseDetailResponse> getCourse(int courseId) async => await _userCourseRemoteDataSource.getCourse(courseId);

  @override
  void saveLocalUserCourses(UserCourseResponse userCourseResponse) {
    return _progressCoursesLocalStorage.saveProgressCourses(userCourseResponse);
  }

  @override
  Future<List<UserCourseResponse>> getUserCoursesLocal() async {
    return _progressCoursesLocalStorage.getUserCoursesLocal();
  }

  @override
  void saveLocalCurriculum(CurriculumResponse curriculumResponse, int id) {
    return _curriculumLocalStorage.saveCurriculum(curriculumResponse, id);
  }

  @override
  Future<List<CurriculumResponse>> getCurriculumLocal(int id) async {
    return _curriculumLocalStorage.getCurriculumLocal(id);
  }
}
