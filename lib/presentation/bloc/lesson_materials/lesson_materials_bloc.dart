import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

part 'lesson_materials_event.dart';

part 'lesson_materials_state.dart';

class LessonMaterialsBloc extends Bloc<LessonMaterialsEvent, LessonMaterialsState> {
  LessonMaterialsBloc() : super(InitialLessonMaterialsState()) {
    CancelToken? _requestCancelToken;

    on<LoadMaterialsEvent>((event, emit) async {
      emit(LoadingMaterialsState());

      var status = await Permission.storage.status;

      if (!status.isGranted) {
        await Permission.storage.request();
      }

      try {
        _requestCancelToken?.cancel();
        _requestCancelToken = CancelToken();

        final response = await HttpService().dio.get<List<int>>(
              event.url,
              onReceiveProgress: (int received, int total) async {},
              options: Options(
                responseType: ResponseType.bytes,
              ),
              cancelToken: _requestCancelToken,
            );

        final file = File('/storage/emulated/0/Download/${event.fileName}');

        if (!file.existsSync()) {
          final raf = file.openSync(mode: FileMode.write);
          raf.writeFromSync(response.data!);
          await raf.close();
        }

        OpenFile.open(file.path);
        emit(LoadedMaterialState());
      } on DioException catch (e) {
        emit(ErrorMaterialState(e.toString()));
      } on Exception catch (e) {
        emit(ErrorMaterialState(e.toString()));
      }
    });
  }
}
