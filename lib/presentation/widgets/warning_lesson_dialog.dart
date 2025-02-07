import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WarningLessonDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'warning'.tr(),
        style: TextStyle(color: Colors.black, fontSize: 20.0),
      ),
      content: Text(
        'warning_lesson_offline'.tr(),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            'ok_dialog_button'.tr(),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
