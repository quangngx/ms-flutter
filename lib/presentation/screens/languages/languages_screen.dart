import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/languages/languages_response.dart';
import 'package:masterstudy_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  static const String routeName = '/languagesScreen';

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  void initState() {
    BlocProvider.of<LanguagesBloc>(context).add(LoadLanguagesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorApp.mainColor,
        centerTitle: true,
        title: Text(
          // TODO: 19.07.2023 Add translations
          'edit_profile_title'.tr(),
          style: kAppBarTextStyle,
        ),
      ),
      body: BlocListener<LanguagesBloc, LanguagesState>(
        listener: (context, state) {
          if (state is ErrorChangeLanguageState) {
            context.read<LanguagesBloc>().add(LoadLanguagesEvent());
          }
        },
        child: BlocBuilder<LanguagesBloc, LanguagesState>(
          builder: (context, state) {
            List<LanguagesResponse> languagesResponse = [];
            if (state is LoadingLanguagesState) {
              return LoaderWidget(
                loaderColor: ColorApp.mainColor,
              );
            }

            if (state is LoadedLanguagesState) {
              languagesResponse = state.languagesResponse;
            }

            if (state is LoadingChangeLanguageState) {
              return Center(
                child: LoaderWidget(
                  loaderColor: ColorApp.mainColor,
                ),
              );
            }

            if (state is ErrorLanguagesState) {
              return ErrorCustomWidget(onTap: () => context.read<LanguagesBloc>().add(LoadLanguagesEvent()));
            }

            return SafeArea(
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: languagesResponse.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = languagesResponse[index];

                      return InkWell(
                        onTap: () => context.read<LanguagesBloc>().add(SelectLanguageEvent(item.code, context)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.nativeName,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Image.network(item.countryFlagUrl),
                                ],
                              ),
                              if (preferences.getString(PreferencesName.selectedLangAbbr) == item.code)
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
