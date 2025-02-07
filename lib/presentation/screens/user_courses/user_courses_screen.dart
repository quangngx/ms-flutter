import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/presentation/bloc/courses/user_courses_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:masterstudy_app/presentation/screens/user_courses/widgets/course_widget.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/unauthorized_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class UserCoursesScreen extends StatefulWidget {
  UserCoursesScreen() : super();

  @override
  State<StatefulWidget> createState() => _UserCoursesScreenState();
}

class _UserCoursesScreenState extends State<UserCoursesScreen> {
  @override
  void initState() {
    context.read<UserCoursesBloc>().add(LoadUserCoursesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: ColorApp.mainColor,
        title: Text(
          'user_courses_screen_title'.tr(),
          style: kAppBarTextStyle,
        ),
      ),
      body: BlocBuilder<UserCoursesBloc, UserCoursesState>(
        builder: (context, state) {
          List<PostsBean?> courses = [];

          if (state is InitialUserCoursesState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is EmptyUserCoursesState) {
            return EmptyWidget(
              imgIcon: IconPath.emptyCourses,
              title: 'no_user_courses_screen_title'.tr(),
              buttonText: 'add_courses_button'.tr(),
              onTap: () => context.read<NavigationBloc>().add(ChangeNavEvent(0)),
            );
          }

          if (state is UnauthorizedState) {
            return UnauthorizedWidget(
              onTap: () => context.read<NavigationBloc>().add(ChangeNavEvent(4)),
            );
          }

          if (state is LoadedUserCoursesState) {
            courses = state.courses;
          }

          if (state is ErrorUserCoursesState)
            return Center(
              child: ErrorCustomWidget(
                message: state.message,
                onTap: () => BlocProvider.of<UserCoursesBloc>(context).add(LoadUserCoursesEvent()),
              ),
            );

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final item = courses[index];

              return CourseItem(item!);
            },
          );
        },
      ),
    );
  }
}
