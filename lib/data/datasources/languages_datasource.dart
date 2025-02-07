import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/languages/languages_response.dart';

abstract class LanguagesDataSource {
  Future<List<LanguagesResponse>> getLanguages();

  Future<Map<String, dynamic>> getTranslations({String? langAbbr});
}

class LanguagesRemoteDataSource extends LanguagesDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<List<LanguagesResponse>> getLanguages() async {
    try {
      Response response = await _httpService.dio.get(
        '/languages',
      );

      final responseList = response.data as List;

      return responseList.map((e) => LanguagesResponse.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getTranslations({String? langAbbr}) async {
    Map<String, dynamic> queryParams = {
      'lang': langAbbr,
    };

    try {
      Response response = await _httpService.dio.get(
        '/translations',
        queryParameters: queryParams,
      );

      return Future.value(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
