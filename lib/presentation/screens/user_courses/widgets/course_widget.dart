import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/user_course/user_course_screen.dart';
import 'package:masterstudy_app/presentation/widgets/app_elevated_button.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class CourseItem extends StatelessWidget {
  const CourseItem(
    this.postsBean, {
    key,
  }) : super(key: key);

  final PostsBean postsBean;

  String get category => postsBean.categoriesObject.isNotEmpty && postsBean.categoriesObject.first?.name != null
      ? postsBean.categoriesObject.first!.name
      : '';

  @override
  Widget build(BuildContext context) {
    final double imgHeight = (MediaQuery.of(context).size.width > 450) ? 370.0 : 160.0;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
      child: Card(
        borderOnForeground: true,
        elevation: 2.5,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserCourseScreen(
                        postsBean: postsBean,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: postsBean.courseId ?? 0,
                  child: CachedNetworkImage(
                    imageUrl: postsBean.appImage,
                    fit: BoxFit.fill,
                    placeholder: (ctx, url) => SizedBox(
                      height: imgHeight,
                    ),
                    errorWidget: (BuildContext context, String url, dynamic error) {
                      return SizedBox(
                        height: imgHeight,
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailScreen(postsBean.categoriesObject.first),
                    ),
                  );

                },
                child: Text(
                  '${unescape.convert(category)} >',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2a3045).withOpacity(0.5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserCourseScreen(
                        postsBean: postsBean,
                      ),
                    ),
                  );
                },
                child: Text(
                  unescape.convert(postsBean.title ?? 'no_info'.tr()),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 22,
                    color: ColorApp.dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: int.parse(postsBean.progress ?? '0') / 100,
                    backgroundColor: Color(0xFFD7DAE2),
                    valueColor: AlwaysStoppedAnimation(ColorApp.secondaryColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    postsBean.duration ?? '',
                    style: TextStyle(
                      color: Color(0xFF2a3045).withOpacity(0.5),
                    ),
                  ),
                  Text(
                    postsBean.progressLabel ?? '',
                    style: TextStyle(
                      color: Color(0xFF2a3045).withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16, bottom: 16),
              child: AppElevatedButton.secondary(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserCourseScreen(
                        postsBean: postsBean,
                      ),
                    ),
                  );
                },
                child: Text(
                  'continue_button'.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
