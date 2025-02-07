import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/instructors/instructors_response.dart';

abstract class InstructorDataSource {
  Future<InstructorsResponse> getInstructors(Map<String, dynamic> params);
}

class InstructorRemoteDataSource extends InstructorDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<InstructorsResponse> getInstructors(Map<String, dynamic> params) async {
    try {
      Response response = await _httpService.dio.get(
        '/instructors',

        // TODO: 18.09.2023 Пока что так, по причине того что возвращает инструкторов неверное
        // queryParameters: params,
      );
      return InstructorsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
