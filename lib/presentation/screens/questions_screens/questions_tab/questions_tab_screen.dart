import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/questions/questions_response.dart';
import 'package:masterstudy_app/presentation/bloc/questions_bloc/question_add/question_add_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/questions_bloc/questions/questions_bloc.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/question_ask/question_ask_screen.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/tabs/questions_all_widget.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/tabs/questions_my_widget.dart';
import 'package:masterstudy_app/presentation/widgets/colored_tabbar_widget.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class QuestionsScreenArgs {
  QuestionsScreenArgs(this.lessonId, this.page);

  final int lessonId;
  final int page;
}

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen() : super();

  static const String routeName = '/questionsScreen';

  @override
  Widget build(BuildContext context) {
    QuestionsScreenArgs args = ModalRoute.of(context)?.settings.arguments as QuestionsScreenArgs;

    return BlocProvider(
      create: (context) => QuestionsBloc(),
      child: QuestionsWidget(args.lessonId, args.page),
    );
  }
}

class QuestionsWidget extends StatefulWidget {
  const QuestionsWidget(this.lessonId, this.page) : super();
  final int lessonId;
  final int page;

  @override
  State<StatefulWidget> createState() => QuestionsWidgetState();
}

class QuestionsWidgetState extends State<QuestionsWidget> {
  late QuestionsResponse questionsAll;
  late QuestionsResponse questionsMy;
  final _replyController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<QuestionsBloc>(context).add(LoadQuestionsEvent(widget.lessonId, widget.page, '', ''));
    super.initState();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionAddBloc(),
      child: BlocListener<QuestionAddBloc, QuestionAddState>(
        listener: (context, state) {
          if (state is SuccessQuestionAddState) {
            BlocProvider.of<QuestionsBloc>(context).add(LoadQuestionsEvent(widget.lessonId, widget.page, '', ''));
          }

          if (state is ErrorQuestionAddState) {
            showFlutterToast(title: state.message);
          }
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF273044),
              title: Text(
                'back_to_course'.tr(),
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              bottom: ColoredTabBar(
                Colors.white,
                TabBar(
                  indicatorColor: ColorApp.mainColor,
                  tabs: [
                    Tab(
                      text: 'all_questions'.tr(),
                    ),
                    Tab(
                      text: 'my_questions'.tr(),
                    ),
                  ],
                ),
              ),
            ),
            body: BlocBuilder<QuestionsBloc, QuestionsState>(
              builder: (context, state) {
                if (state is InitialQuestionsState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.mainColor,
                  );
                }

                if (state is LoadedQuestionsState) {
                  questionsAll = state.questionsResponseAll;
                  questionsMy = state.questionsResponseMy;

                  return TabBarView(
                    children: <Widget>[
                      RefreshIndicator(
                        onRefresh: () async => BlocProvider.of<QuestionsBloc>(context).add(
                          LoadQuestionsEvent(widget.lessonId, widget.page, '', ''),
                        ),
                        child: QuestionAllWidget(
                          questionsAll: questionsAll,
                          lessonId: widget.lessonId,
                        ),
                      ),
                      QuestionsMyWidget(
                        questionsMy: questionsMy,
                        lessonId: widget.lessonId,
                      ),
                    ],
                  );
                }

                return ErrorCustomWidget(
                  onTap: () => BlocProvider.of<QuestionsBloc>(context).add(
                    LoadQuestionsEvent(widget.lessonId, widget.page, '', ''),
                  ),
                );
              },
            ),
            bottomNavigationBar: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFF273044),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(.1),
                    offset: Offset(0, 0),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: MaterialButton(
                    height: kButtonHeight,
                    color: ColorApp.mainColor,
                    onPressed: () {
                      if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                        showDialogError(context, 'demo_mode'.tr());
                      } else {
                        Navigator.of(context).pushNamed(
                          QuestionAskScreen.routeName,
                          arguments: QuestionAskScreenArgs(widget.lessonId),
                        );
                      }
                    },
                    child: Text(
                      'ask_your_question'.tr(),
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
