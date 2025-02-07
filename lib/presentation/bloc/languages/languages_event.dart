part of 'languages_bloc.dart';

abstract class LanguagesEvent {}

class LoadLanguagesEvent extends LanguagesEvent {}

class SelectLanguageEvent extends LanguagesEvent {
  SelectLanguageEvent(this.langAbbr, this.context);

  final String langAbbr;
  final BuildContext context;
}
