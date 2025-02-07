import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/presentation/bloc/search/search_bloc.dart';
import 'package:masterstudy_app/presentation/screens/search/widgets/popular_course_widget.dart';
import 'package:masterstudy_app/presentation/screens/search/widgets/popular_search_widget.dart';
import 'package:masterstudy_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc()..add(FetchEvent()),
      child: Scaffold(
        backgroundColor: ColorApp.bgColorGrey,
        appBar: AppBar(
          backgroundColor: ColorApp.mainColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'search_title'.tr(),
            style: kAppBarTextStyle,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 16),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 10, right: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(kRadius),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    SearchDetailScreen.routeName,
                    arguments: SearchDetailScreenArgs(),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadius),
                  ),
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'search_bar_title'.tr(),
                                style: TextStyle(color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                            Icon(
                              Icons.search,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            List<String> popularSearches = [];
            List<CoursesBean?> courses = [];

            if (state is InitialSearchState) {
              return LoaderWidget(
                loaderColor: ColorApp.mainColor,
              );
            }

            if (state is LoadedSearchState) {
              popularSearches = state.popularSearch;
              courses = state.newCourses;
            }

            if (state is ErrorSearchState) {
              return ErrorCustomWidget(
                onTap: () => BlocProvider.of<SearchBloc>(context).add(FetchEvent()),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => BlocProvider.of<SearchBloc>(context).add(FetchEvent()),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PopularSearchWidget(popularSearch: popularSearches),
                      PopularCourseWidget(courses: courses),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
