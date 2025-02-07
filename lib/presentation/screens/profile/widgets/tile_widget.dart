import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class TileWidget extends StatelessWidget {
  const TileWidget({
    Key? key,
    required this.title,
    required this.assetPath,
    required this.onTap,
    this.textColor,
    this.iconColor,
  }) : super(key: key);

  final String title;
  final String assetPath;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      assetPath,
      colorFilter: ColorFilter.mode(iconColor == null ? ColorApp.mainColor : iconColor!, BlendMode.srcIn),
    );

    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          leading: SizedBox(
            child: svg,
            width: 23,
            height: 23,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: textColor == null ? ColorApp.dark : textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: onTap,
        ),
        Divider(
          height: 0.0,
          thickness: 1.0,
          color: ColorApp.kDividerColor,
        ),
      ],
    );
  }
}
