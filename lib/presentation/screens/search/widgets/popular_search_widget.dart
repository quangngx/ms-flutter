import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class PopularSearchWidget extends StatefulWidget {
  const PopularSearchWidget({super.key, required this.popularSearch});

  final List<String> popularSearch;

  @override
  State<PopularSearchWidget> createState() => _PopularSearchWidgetState();
}

class _PopularSearchWidgetState extends State<PopularSearchWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.popularSearch.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'popular_searchs'.tr(),
            style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                  color: ColorApp.dark,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: widget.popularSearch.map((value) => chip(unescape.convert(value))).toList(),
        ),
      ],
    );
  }

  Widget chip(String label) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        SearchDetailScreen.routeName,
        arguments: SearchDetailScreenArgs(searchText: label),
      ),
      child: Chip(
        labelPadding: EdgeInsets.all(5.0),
        backgroundColor: Colors.white,
        elevation: 2.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(6.0),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
