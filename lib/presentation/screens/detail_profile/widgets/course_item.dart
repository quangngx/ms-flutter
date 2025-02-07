import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/category/category.dart';
import 'package:masterstudy_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailCourseItem extends StatelessWidget {
  const DetailCourseItem({
    Key? key,
    required this.image,
    this.category,
    required this.title,
    required this.stars,
    required this.reviews,
    required this.price,
    required this.oldPrice,
    required this.free,
  }) : super(key: key);

  final String? image;
  final Category? category;
  final String? title;
  final double stars;
  final int? reviews;
  final String? price;
  final String? oldPrice;
  final bool? free;

  String? get categoryName => category != null ? category?.name : '';

  @override
  Widget build(BuildContext context) {
    Widget? buildPrice;

    if (free!) {
      buildPrice = Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
        child: Text(
          'course_free_price'.tr(),
          style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                color: ColorApp.dark,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    }

    if (price != null) {
      buildPrice = Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
        child: Row(
          children: <Widget>[
            Text(
              price ?? '',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headlineSmall
                  ?.copyWith(color: ColorApp.dark, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
            ),
            Visibility(
              visible: oldPrice != null,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  oldPrice.toString(),
                  style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                        color: Color(0xFF999999),
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      child: Card(
        borderOnForeground: true,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: FadeInImage.memoryNetwork(
                image: image!,
                placeholder: kTransparentImage,
                width: double.infinity,
                height: 160,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailScreen(category),
                    ),
                  );
                },
                child: Text(
                  "${unescape.convert(categoryName ?? '')} >",
                  style: TextStyle(fontSize: 18, color: Color(0xFF2a3045).withOpacity(0.5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 16.0, right: 16.0),
              child: Text(
                title ?? '',
                maxLines: 2,
                style: TextStyle(fontSize: 22, color: ColorApp.dark),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Divider(
                color: Color(0xFFe0e0e0),
                thickness: 1.3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 15.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  RatingBar.builder(
                    initialRating: stars,
                    minRating: 0,
                    direction: Axis.horizontal,
                    tapOnlyMode: true,
                    allowHalfRating: true,
                    glow: false,
                    ignoreGestures: true,
                    itemCount: 5,
                    itemSize: 19,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '$stars ($reviews)',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            buildPrice!,
          ],
        ),
      ),
    );
  }
}
