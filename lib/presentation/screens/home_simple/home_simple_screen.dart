import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/presentation/bloc/home_simple/home_simple_bloc.dart';
import 'package:masterstudy_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/presentation/widgets/course_grid_item.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class HomeSimpleScreen extends StatelessWidget {
  const HomeSimpleScreen() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.bgColorGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorApp.mainColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(26),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                SearchDetailScreen.routeName,
                arguments: SearchDetailScreenArgs(),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kRadius),
                ),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'search_bar_title'.tr(),
                          style: TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeSimpleBloc, HomeSimpleState>(
        builder: (context, state) {
          List<CoursesBean?> courses = [];

          if (state is InitialHomeSimpleState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is LoadedHomeSimpleState) {
            courses = state.coursesNew;
          }

          if (state is EmptyHomeSimpleState) {
            return EmptyWidget(
              imgIcon: IconPath.emptyCourses,
              title: 'courses_is_empty'.tr(),
            );
          }

          if (state is ErrorHomeSimpleState) {
            return ErrorCustomWidget(
              onTap: () => BlocProvider.of<HomeSimpleBloc>(context).add(LoadHomeSimpleEvent()),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, left: 30.0, right: 30.0, bottom: 10.0),
                  child: Text(
                    'new_courses_title'.tr(),
                    style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                          color: ColorApp.dark,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: AlignedGridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final item = courses[index];

                      return CourseGridItem(item);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
