import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/user_course/user_course_bloc.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/detail_profile_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/quiz_lesson/quiz_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/text_lesson/text_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/lesson_video_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/zoom_lesson/zoom.dart';
import 'package:masterstudy_app/presentation/screens/user_course/widgets/download_widget.dart';
import 'package:masterstudy_app/presentation/widgets/app_elevated_button.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class UserCourseScreen extends StatelessWidget {
  const UserCourseScreen({super.key, required this.postsBean});

  static const String routeName = '/userCourseScreen';

  final PostsBean postsBean;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCourseBloc(),
      child: UserCourseWidget(postsBean),
    );
  }
}

class UserCourseWidget extends StatefulWidget {
  const UserCourseWidget(this.postsBean) : super();

  final PostsBean postsBean;

  @override
  State<StatefulWidget> createState() => UserCourseWidgetState();
}

class UserCourseWidgetState extends State<UserCourseWidget> {
  late ScrollController _scrollController;
  String title = '';

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (MediaQuery.of(context).size.height / 3 - (kToolbarHeight));
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    BlocProvider.of<UserCourseBloc>(context).add(LoadUserDetailCourseEvent(widget.postsBean));

    _scrollController = ScrollController()
      ..addListener(() {
        if (!_isAppBarExpanded) {
          setState(() {
            title = '';
          });
        } else {
          setState(() {
            title = unescape.convert(widget.postsBean.title!);
          });
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num kef = (MediaQuery.of(context).size.height > 690) ? 3.3 : 3;

    return BlocBuilder<UserCourseBloc, UserCourseState>(
      builder: (context, state) {
        return Scaffold(
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: ColorApp.mainColor,
                  title: Text(title, style: kAppBarTextStyle),
                  expandedHeight: MediaQuery.of(context).size.height / kef,
                  floating: false,
                  pinned: true,
                  snap: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      children: <Widget>[
                        Hero(
                          tag: widget.postsBean.courseId ?? 0,
                          child: CachedNetworkImage(
                            imageUrl: widget.postsBean.appImage ??
                                'http://ms.stylemix.biz/wp-content/uploads/elementor/thumbs/placeholder-1919x1279-plpkge6q8d1n11vbq6ckurd53ap3zw1gbw0n5fqs0o.gif',
                            placeholder: (ctx, url) => SizedBox(
                              height: MediaQuery.of(context).size.height / 3 + MediaQuery.of(context).padding.top,
                            ),
                            errorWidget: (BuildContext context, String url, dynamic error) {
                              return Center(
                                child: Icon(Icons.error),
                              );
                            },
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 3 + MediaQuery.of(context).padding.top,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF2A3045).withOpacity(0.7),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          if (state is LoadedUserCourseState) {
                                            Navigator.pushNamed(
                                              context,
                                              DetailProfileScreen.routeName,
                                              arguments: DetailProfileScreenArgs.fromId(
                                                teacherId: int.parse(widget.postsBean.author?.id ?? ''),
                                              ),
                                            );
                                          }
                                        },
                                        child: CircleAvatar(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                            child: CachedNetworkImage(
                                              imageUrl: widget.postsBean.author!.avatarUrl!,
                                              placeholder: (BuildContext context, String url) {
                                                return LoaderWidget();
                                              },
                                              errorWidget: (BuildContext context, String url, dynamic widget) {
                                                return Icon(
                                                  Icons.error_outline_rounded,
                                                  color: ColorApp.redColor,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      unescape.convert(widget.postsBean.title ?? 'no_info'.tr()),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white, fontSize: 24),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      child: SizedBox(
                                        height: 6,
                                        child: LinearProgressIndicator(
                                          value: int.parse(
                                                state is LoadedUserCourseState
                                                    ? state.response?.progressPercent ?? ''
                                                    : '0',
                                              ) /
                                              100,
                                          backgroundColor: Color(0xFFD7DAE2),
                                          valueColor: AlwaysStoppedAnimation(ColorApp.secondaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: AppElevatedButton.secondary(
                                            onPressed: () {
                                              bool containsLastLesson = false;
                                              int? lessonId;
                                              String? lessonType;

                                              if (state is LoadedUserCourseState) {
                                                if (state.response?.materials != null &&
                                                    state.response!.materials.isNotEmpty) {
                                                  MaterialItem? notCompletedCurriculum = state.response!.materials
                                                      .firstWhere((element) => !element.completed);

                                                  setState(() {
                                                    containsLastLesson = true;
                                                    lessonId = notCompletedCurriculum.postId;
                                                    lessonType = notCompletedCurriculum.type;
                                                  });

                                                  if (containsLastLesson) {
                                                    if (lessonId != null) {
                                                      _openLesson(lessonType, lessonId!);
                                                    }
                                                  }
                                                }
                                              }
                                            },
                                            child: Text(
                                              'continue_button'.tr(),
                                            ),
                                          ),
                                        ),
                                        DownloadButtonWidget(
                                          curriculumResponse: state is LoadedUserCourseState ? state.response : null,
                                          postsBean: widget.postsBean,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Builder(
              builder: (BuildContext context) {
                CurriculumResponse? response;

                if (state is InitialUserCourseState) {
                  return LoaderWidget(
                    loaderColor: ColorApp.mainColor,
                  );
                }

                if (state is LoadedUserCourseState) {
                  response = state.response;

                  if (state.response!.sections.isEmpty) {
                    return EmptyWidget(
                      imgIcon: IconPath.emptyCourses,
                      title: 'empty_sections_course'.tr(),
                    );
                  }
                }

                if (state is ErrorUserCourseState) {
                  return Center(
                    child: ErrorCustomWidget(
                      onTap: () => BlocProvider.of<UserCourseBloc>(context).add(
                        LoadUserDetailCourseEvent(widget.postsBean),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: response?.sections.length,
                  itemBuilder: (context, index) {
                    final sectionItem = response?.sections[index]!;

                    List<MaterialItem?> filteredList =
                        response!.materials.where((element) => element.sectionId == sectionItem!.id).toList();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                '${'section'.tr()} ${sectionItem?.order}',
                                style: TextStyle(color: Color(0xFFAAAAAA)),
                              ),
                              Text(
                                sectionItem?.title ?? '',
                                style: TextStyle(
                                  color: Color(0xFF273044),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (response.materials.isNotEmpty)
                          Column(
                            children: filteredList.map((value) {
                              return _buildLesson(value!);
                            }).toList(),
                          )
                        else
                          const SizedBox(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLesson(MaterialItem materialItem) {
    bool locked = materialItem.locked && dripContentEnabled;
    String? duration = materialItem.duration ?? '';
    Widget icon = const SizedBox();

    switch (materialItem.type) {
      case 'video':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.play,
            colorFilter: (!locked)
                ? ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn)
                : ColorFilter.mode(Color(0xFF2A3045).withOpacity(0.3), BlendMode.srcIn),
          ),
        );
        break;
      case 'stream':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.videoCamera,
            colorFilter: (!locked)
                ? ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn)
                : ColorFilter.mode(Color(0xFF2A3045).withOpacity(0.3), BlendMode.srcIn),
          ),
        );
        break;
      case 'slide':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.slides,
            colorFilter: (!locked)
                ? ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn)
                : ColorFilter.mode(Color(0xFF2A3045).withOpacity(0.3), BlendMode.srcIn),
          ),
        );
        break;
      case 'assignment':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.assignment,
            colorFilter: (!locked)
                ? ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn)
                : ColorFilter.mode(Color(0xFF2A3045).withOpacity(0.3), BlendMode.srcIn),
          ),
        );
        break;
      case 'quiz':
        duration = materialItem.questions;
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.question,
            colorFilter: (!locked)
                ? ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn)
                : ColorFilter.mode(Color(0xFF2A3045).withOpacity(0.3), BlendMode.srcIn),
          ),
        );
        break;
      case 'text':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.text,
            colorFilter: (!locked)
                ? ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn)
                : ColorFilter.mode(Color(0xFF2A3045).withOpacity(0.3), BlendMode.srcIn),
          ),
        );
        break;
      case 'lesson':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.text,
            colorFilter: (!locked)
                ? ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn)
                : ColorFilter.mode(Color(0xFF2A3045).withOpacity(0.3), BlendMode.srcIn),
          ),
        );
        break;
      case 'zoom_conference':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.zoom,
          ),
        );
        break;
      case '':
        icon = SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            IconPath.text,
            colorFilter: (!locked)
                ? ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn)
                : ColorFilter.mode(Color(0xFF2A3045).withOpacity(0.3), BlendMode.srcIn),
          ),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: InkWell(
        onTap: locked ? null : () => _openLesson(materialItem.type, materialItem.postId),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Color(0xFFF3F5F9)),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      icon,
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            materialItem.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(color: locked ? Colors.black.withOpacity(0.3) : Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Visibility(
                      visible: locked,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(
                          IconPath.lock,
                          colorFilter: ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: SvgPicture.asset(IconPath.durationCurriculum),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              duration ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black.withOpacity(0.3)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLesson(String? type, int id) {
    Future result;

    switch (type) {
      case 'quiz':
        result = Navigator.of(context).pushNamed(
          QuizLessonScreen.routeName,
          arguments: QuizLessonScreenArgs(
            int.parse(widget.postsBean.courseId!),
            id,
            widget.postsBean.author!.avatarUrl!,
            widget.postsBean.author!.login!,
          ),
        );
        break;
      case 'text':
        result = Navigator.of(context).pushNamed(
          TextLessonScreen.routeName,
          arguments: TextLessonScreenArgs(
            int.parse(widget.postsBean.courseId!),
            id,
            widget.postsBean.author!.avatarUrl!,
            widget.postsBean.author!.login!,
            false,
            true,
          ),
        );
        break;
      case 'video':
        result = Navigator.of(context).pushNamed(
          LessonVideoScreen.routeName,
          arguments: LessonVideoScreenArgs(
            int.tryParse(widget.postsBean.courseId!)!,
            id,
            widget.postsBean.author!.avatarUrl!,
            widget.postsBean.author!.login!,
            false,
            true,
          ),
        );
        break;
      case 'assignment':
        result = Navigator.of(context).pushNamed(
          AssignmentScreen.routeName,
          arguments: AssignmentScreenArgs(
            int.tryParse(widget.postsBean.courseId!)!,
            id,
            widget.postsBean.author!.avatarUrl!,
            widget.postsBean.author!.login!,
          ),
        );
        break;
      case 'zoom_conference':
        result = Navigator.of(context).pushNamed(
          LessonZoomScreen.routeName,
          arguments: LessonZoomScreenArgs(
            int.tryParse(widget.postsBean.courseId!)!,
            id,
            widget.postsBean.author!.avatarUrl!,
            widget.postsBean.author!.login!,
            false,
            true,
          ),
        );
        break;
      default:
        result = Navigator.of(context).pushNamed(
          TextLessonScreen.routeName,
          arguments: TextLessonScreenArgs(
            int.tryParse(widget.postsBean.courseId!)!,
            id,
            widget.postsBean.author!.avatarUrl!,
            widget.postsBean.author!.login!,
            false,
            true,
          ),
        );
    }
    result.then(
      (value) => {
        BlocProvider.of<UserCourseBloc>(context).add(
          LoadUserDetailCourseEvent(widget.postsBean),
        ),
      },
    );
  }
}
