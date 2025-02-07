import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class AnswerItem extends StatelessWidget {
  const AnswerItem({
    Key? key,
    this.authorName,
    required this.dateTime,
    required this.content,
  }) : super(key: key);

  final String? authorName;
  final String? dateTime;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: SvgPicture.asset(
                        IconPath.star,
                        colorFilter: ColorFilter.mode(ColorApp.mainColor, BlendMode.srcIn),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        authorName ?? '',
                        style: TextStyle(color: ColorApp.mainColor),
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  width: 40,
                  indent: 2,
                  endIndent: 2,
                  thickness: 2,
                  color: Color(0xFFE2E5EB),
                ),
                Expanded(
                  child: Text(
                    dateTime ?? '',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 40,
                  indent: 2,
                  endIndent: 2,
                  thickness: 2,
                  color: Color(0xFFE2E5EB),
                ),
                Expanded(
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: SvgPicture.asset(
                      IconPath.flag,
                      colorFilter: ColorFilter.mode(Color(0xFFAAAAAA), BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              content ?? '',
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xFF273044),
              ),
            ),
          ),
        ],
      ),
    );
  }
}