import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/presentation/bloc/user_course/download_course/download_course_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class DownloadButtonWidget extends StatefulWidget {
  const DownloadButtonWidget({
    super.key,
    required this.postsBean,
    required this.curriculumResponse,
  });

  final PostsBean postsBean;
  final CurriculumResponse? curriculumResponse;

  @override
  State<DownloadButtonWidget> createState() => _DownloadButtonWidgetState();
}

class _DownloadButtonWidgetState extends State<DownloadButtonWidget> {
  IconData icon = Icons.cloud_download_outlined;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloadCourseBloc()
        ..add(
          CheckCourseDownloadEvent(courseHash: widget.postsBean.hash),
        ),
      child: BlocListener<DownloadCourseBloc, DownloadCourseState>(
        listener: (context, state) {
          if (state is LoadedDownloadCourseState) {
            icon = Icons.check;
          }

          if (state is ErrorDownloadCourseState) {
            icon = Icons.error_outline_rounded;

            Future.delayed(const Duration(seconds: 5), () {
              icon = Icons.cloud_download_outlined;
            });
          }
        },
        child: BlocBuilder<DownloadCourseBloc, DownloadCourseState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: CircleAvatar(
                radius: 22.0,
                backgroundColor: ColorApp.mainColor,
                child: IconButton(
                  tooltip: state is ErrorDownloadCourseState ? state.message : null,
                  onPressed: state is LoadingDownloadCourseState || state is LoadedDownloadCourseState
                      ? null
                      : () async {
                          context.read<DownloadCourseBloc>().add(
                                DownloadEvent(
                                  curriculumResponse: widget.curriculumResponse,
                                  postsBean: widget.postsBean,
                                ),
                              );
                        },
                  icon: state is LoadingDownloadCourseState
                      ? LoaderWidget()
                      : Icon(
                          icon,
                          color: Colors.white,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
