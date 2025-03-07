import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class CourseGridItem extends StatelessWidget {
  CourseGridItem(this.coursesBean);

  final CoursesBean? coursesBean;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      onTap: () => Navigator.pushNamed(
        context,
        CourseScreen.routeName,
        arguments: CourseScreenArgs.fromCourseBean(coursesBean!),
      ),
      child: CourseGridCard(coursesBean: coursesBean),
    );
  }
}

class CourseGridCard extends StatelessWidget {
  const CourseGridCard({Key? key, required this.coursesBean}) : super(key: key);

  final CoursesBean? coursesBean;

  double? get rating => coursesBean?.rating?.average?.toDouble();

  num? get reviews => coursesBean?.rating?.total;

  String? get categoryName => coursesBean?.categoriesObject != null && coursesBean!.categoriesObject.isNotEmpty
      ? coursesBean?.categoriesObject.first?.name ?? null
      : null;

  @override
  Widget build(BuildContext context) {
    Widget buildPrice = Text(
      (coursesBean?.price != null && coursesBean?.price?.free != null) && coursesBean?.price?.free == true
          ? 'course_free_price'.tr()
          : coursesBean?.price?.price ?? '',
      style: Theme.of(context).primaryTextTheme.titleMedium!.copyWith(
            color: ColorApp.dark,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
    );

    if (coursesBean?.price?.oldPrice != null) {
      buildPrice = Row(
        children: [
          buildPrice,
          const SizedBox(width: 4.0),
          Text(
            coursesBean?.price?.oldPrice != null ? coursesBean!.price!.oldPrice! : ' ',
            style: Theme.of(context).primaryTextTheme.titleMedium!.copyWith(
                  color: Color(0xFF999999),
                  fontStyle: FontStyle.normal,
                  decoration: (coursesBean?.price?.oldPrice != null) ? TextDecoration.lineThrough : TextDecoration.none,
                ),
          ),
        ],
      );
    }

    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Hero(
                  tag: coursesBean?.id ?? -1,
                  child: CachedNetworkImage(
                    imageUrl: coursesBean?.images?.small ?? '',
                    placeholder: (BuildContext context, String url) {
                      return LoaderWidget();
                    },
                    errorWidget: (BuildContext context, String url, dynamic error) {
                      return Icon(Icons.error_outline);
                    },
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width > 450 ? 220.0 : 95.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (coursesBean?.status != null)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: ColorApp.secondaryColor,
                    ),
                    child: Text(
                      coursesBean?.status?.label ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (categoryName != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryDetailScreen(coursesBean?.categoriesObject.first),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                child: Text(
                  unescape.convert(categoryName ?? ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12.0,
                      ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Text(
              unescape.convert(coursesBean?.title ?? '') + '\n',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Row(
              children: <Widget>[
                RatingBar.builder(
                  initialRating: rating!,
                  minRating: 0,
                  direction: Axis.horizontal,
                  tapOnlyMode: true,
                  glow: false,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  itemCount: 5,
                  itemSize: 14,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                Text(
                  '$rating ($reviews)',
                  style: Theme.of(context).primaryTextTheme.bodySmall?.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
            child: buildPrice,
          ),
        ],
      ),
    );
  }
}
