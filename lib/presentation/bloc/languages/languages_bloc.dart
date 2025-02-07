import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/services/localization_service.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/languages/languages_response.dart';
import 'package:masterstudy_app/data/repository/languages_repository.dart';

part 'languages_event.dart';

part 'languages_state.dart';

class LanguagesBloc extends Bloc<LanguagesEvent, LanguagesState> {
  LanguagesBloc() : super(InitialLanguagesState()) {
    on<LoadLanguagesEvent>((event, emit) async {
      emit(LoadingLanguagesState());
      try {
        final List<LanguagesResponse> languagesResponse = await _languagesRepository.getLanguages();

        emit(LoadedLanguagesState(languagesResponse: languagesResponse));
      } catch (e, s) {
        logger.e('Error with method getLanguages() - Languages Bloc', e, s);
        emit(ErrorLanguagesState(e.toString()));
      }
    });

    on<SelectLanguageEvent>((event, emit) async {
      emit(LoadingChangeLanguageState());
      try {
        preferences.setString(PreferencesName.selectedLangAbbr, event.langAbbr);

        final Locale locale = Locale(event.langAbbr);

        await EasyLocalization.of(event.context)!.setLocale(locale);

        LocalizationService().load('', locale);

        // ignore: use_build_context_synchronously
        await EasyLocalization.of(event.context)?.delegate.load(locale);

        await WidgetsBinding.instance.performReassemble();

        emit(SuccessChangeLanguageState(event.langAbbr));
      } catch (e, s) {
        emit(ErrorChangeLanguageState());
        logger.e('Error with set language method', e, s);
      }
    });
  }

  final LanguagesRepository _languagesRepository = LanguagesRepositoryImpl();
}
