import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/presentation/widgets/app_elevated_button.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    this.imgIcon,
    this.iconData,
    required this.title,
    this.additionalText,
    this.buttonText,
    this.onTap,
  }) : super(key: key);

  final String? imgIcon;
  final IconData? iconData;
  final String title;
  final String? additionalText;
  final String? buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget? buildButton;

    if (buttonText != null && buttonText!.isNotEmpty) {
      buildButton = Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: AppElevatedButton.secondary(
            onPressed: onTap,
            child: Text(
              buttonText!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (imgIcon != null)
            SvgPicture.asset(
              imgIcon!,
              width: 150,
              height: 150,
            )
          else if (iconData != null)
            Icon(
              iconData,
              size: 150,
              color: Colors.grey[400],
            )
          else
            const SizedBox(),
          const SizedBox(height: 10.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
            ),
          ),
          if (additionalText != null)
            Text(
              additionalText!,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 18,
              ),
            ),
          buildButton ?? const SizedBox(),
        ],
      ),
    );
  }
}
