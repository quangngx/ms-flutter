import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masterstudy_app/data/models/assignment/assignment_response.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_parts/assignment_info.dart';

class AssignmentPreviewWidget extends StatelessWidget {
  const AssignmentPreviewWidget(this.assignmentResponse, this.courseId, this.assignmentId) : super();

  final AssignmentResponse assignmentResponse;
  final int courseId;
  final int assignmentId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
          child: Text(
            '${'assignment_screen_title'.tr()} ' + assignmentResponse.section!.index.toString(),
            style: TextStyle(color: Color(0xFF273044)),
          ),
        ),
        AssignmentInfoWidget(assignmentResponse),
      ],
    );
  }
}
