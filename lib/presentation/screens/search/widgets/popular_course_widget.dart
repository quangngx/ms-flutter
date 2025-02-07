import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/presentation/widgets/course_grid_item.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class PopularCourseWidget extends StatefulWidget {
  const PopularCourseWidget({super.key, required this.courses});

  final List<CoursesBean?> courses;

  @override
  State<PopularCourseWidget> createState() => _PopularCourseWidgetState();
}

class _PopularCourseWidgetState extends State<PopularCourseWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.courses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: EmptyWidget(
          imgIcon: IconPath.emptyCourses,
          title: 'courses_is_empty'.tr(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'new_courses'.tr(),
            style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                  color: ColorApp.dark,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
        AlignedGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.courses.length,
          itemBuilder: (BuildContext context, int index) {
            final item = widget.courses[index];

            return CourseGridItem(item);
          },
        ),
      ],
    );
  }
}
