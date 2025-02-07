import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/core/utils/logger.dart';

class LocalizationService extends AssetLoader {
  LocalizationService();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    String jsonString = await rootBundle.loadString('assets/localization/en.json');

    Map<String, dynamic> queryParams = {
      'lang': locale,
    };

    try {
      final response = await HttpService().dio.get(
            '/translations',
            queryParameters: queryParams,
          );

      Map<String, dynamic> _remoteLocal = response.data as Map<String, dynamic>;

      // The function is made so that if we have new translations
      // and they are not added to the API, but added to json (local) so that it will add them
      (jsonDecode(jsonString) as Map).forEach((key, value) {
        if (!_remoteLocal.containsKey(key)) {
          _remoteLocal[key] = value;
        }
      });

      return _remoteLocal;
    } on DioException catch (e, s) {
      logger.e('Error with load localization - /settings', e, s);

      String jsonString = await rootBundle.loadString('assets/localization/en.json');

      return jsonDecode(jsonString);
    }
  }
}
