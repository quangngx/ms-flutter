import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:masterstudy_app/theme/app_color.dart';

Future<void> showAlertDialog(
  BuildContext context, {
  String? title,
  String? content,
  VoidCallback? onPressed,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title ?? 'error_dialog_title'.tr(),
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        content: Text(content ?? 'no_info'.tr()),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.mainColor,
            ),
            child: Text(
              'ok_dialog_button'.tr(),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed;
            },
          ),
        ],
      );
    },
  );
}

Future<void> showNotAuthorizedDialog(BuildContext context, {VoidCallback? onTap}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    barrierColor: Colors.black.withAlpha(1),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    'not_authenticated'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.mainColor,
                    ),
                    onPressed: onTap,
                    child: Text(
                      'login_label_text'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
