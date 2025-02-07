import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class LanguagesWidget extends StatefulWidget {
  const LanguagesWidget({super.key});

  @override
  State<LanguagesWidget> createState() => _LanguagesWidgetState();
}

class _LanguagesWidgetState extends State<LanguagesWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguagesBloc, LanguagesState>(
      listener: (context, state) {
        if (state is ErrorChangeLanguageState) {
          context.read<LanguagesBloc>().add(LoadLanguagesEvent());
        }
      },
      child: BlocBuilder<LanguagesBloc, LanguagesState>(
        builder: (context, state) {
          if (state is LoadingChangeLanguageState || state is LoadingLanguagesState) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: LoaderWidget(
                loaderColor: ColorApp.mainColor,
              ),
            );
          }

          if (state is ErrorChangeLanguageState) {
            return const SizedBox();
          }

          if (state is LoadedLanguagesState) {
            return PopupMenuButton(
              // TODO: 02.08.2023: Add translation
              tooltip: 'Change language',
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              itemBuilder: (BuildContext context) {
                return state.languagesResponse.map((e) {
                  return PopupMenuItem(
                    value: e.code,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.nativeName,
                          style: TextStyle(color: Colors.black),
                        ),
                        if (preferences.getString(PreferencesName.selectedLangAbbr) == e.code)
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                      ],
                    ),
                  );
                }).toList();
              },
              onSelected: (String selectedLanguage) {
                context.read<LanguagesBloc>().add(
                      SelectLanguageEvent(selectedLanguage, context),
                    );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.language_outlined,
                    color: ColorApp.mainColor,
                  ),
                ),
              ),
            );
          }

          if (state is ErrorLanguagesState) {
            return IconButton(
              onPressed: () => BlocProvider.of<LanguagesBloc>(context).add(LoadLanguagesEvent()),
              icon: Icon(Icons.error_outline_outlined),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
