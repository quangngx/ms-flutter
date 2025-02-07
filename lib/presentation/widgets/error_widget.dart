import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/presentation/widgets/app_elevated_button.dart';

class ErrorCustomWidget extends StatelessWidget {
  const ErrorCustomWidget({required this.onTap, this.message});

  final VoidCallback onTap;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              IconPath.errorIcon,
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            const SizedBox(height: 10.0),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: message ?? 'network_error'.tr(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              child: AppElevatedButton.primary(
                onPressed: onTap,
                child: Text(
                  'error_button'.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
