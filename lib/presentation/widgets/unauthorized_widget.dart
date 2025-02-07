import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class UnauthorizedWidget extends StatelessWidget {
  const UnauthorizedWidget({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'not_authenticated'.tr(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 45,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.mainColor,
              ),
              onPressed: onTap,
              child: Text('login_label_text'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
