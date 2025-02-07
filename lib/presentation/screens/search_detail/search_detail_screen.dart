import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/presentation/bloc/search_detail/search_detail_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/course_grid_item.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class SearchDetailScreenArgs {
  SearchDetailScreenArgs({
    this.searchText,
    this.categoryId,
  });

  final String? searchText;
  final int? categoryId;
}

class SearchDetailScreen extends StatelessWidget {
  const SearchDetailScreen() : super();

  static const String routeName = '/searchDetailScreen';

  @override
  Widget build(BuildContext context) {
    SearchDetailScreenArgs args = ModalRoute.of(context)?.settings.arguments as SearchDetailScreenArgs;

    return BlocProvider<SearchDetailBloc>(
      create: (context) => SearchDetailBloc(),
      child: SearchDetailWidget(
        searchText: args.searchText,
        categoryId: args.categoryId,
      ),
    );
  }
}

class SearchDetailWidget extends StatefulWidget {
  const SearchDetailWidget({
    this.searchText,
    this.categoryId,
  }) : super();

  final String? searchText;
  final int? categoryId;

  @override
  State<StatefulWidget> createState() => _SearchDetailWidgetState();
}

class _SearchDetailWidgetState extends State<SearchDetailWidget> {
  List<CoursesBean?> _courses = [];
  final _searchQueryController = TextEditingController();

  @override
  void initState() {
    if (widget.searchText != null && widget.searchText!.isNotEmpty) {
      _searchQueryController.text = widget.searchText!;
    }

    BlocProvider.of<SearchDetailBloc>(context).add(
      FetchEvent(_searchQueryController.text, widget.categoryId),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.bgColorGrey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: TextField(
          autofocus: true,
          cursorColor: ColorApp.mainColor,
          controller: _searchQueryController,
          decoration: InputDecoration(
            hintText: '${'search_bar_title'.tr()}...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.trim().length > 1)
              BlocProvider.of<SearchDetailBloc>(context).add(
                FetchEvent(value, widget.categoryId),
              );
          },
        ),
      ),
      body: BlocBuilder<SearchDetailBloc, SearchDetailState>(
        builder: (context, state) {
          if (state is LoadingSearchDetailState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is NotingFoundSearchDetailState) {
            return EmptyWidget(
              iconData: Icons.search,
              title: 'nothing_found_search'.tr(),
              additionalText: _searchQueryController.text,
            );
          }

          if (state is LoadedSearchDetailState) {
            _courses = state.courses;
          }

          if (state is ErrorSearchDetailState) {
            return ErrorCustomWidget(
              onTap: () => BlocProvider.of<SearchDetailBloc>(context).add(
                FetchEvent(_searchQueryController.text, widget.categoryId),
              ),
            );
          }

          return AlignedGridView.count(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            itemCount: _courses.length,
            itemBuilder: (context, index) {
              final item = _courses[index];

              return CourseGridItem(item);
            },
          );
        },
      ),
    );
  }
}
