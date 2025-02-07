import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

@JsonSerializable()
class AppSettings {
  AppSettings({
    required this.addons,
    required this.homeLayout,
    required this.options,
    required this.demo,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  final AddonsBean? addons;
  @JsonKey(name: 'home_layout')
  final List<HomeLayoutBean?> homeLayout;
  final OptionsBean? options;
  final bool? demo;

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

@JsonSerializable()
class AddonsBean {
  AddonsBean({
    required this.shareware,
    required this.sequentialDripContent,
    required this.gradebook,
    required this.liveStreams,
    required this.enterpriseCourses,
    required this.assignments,
    required this.pointSystem,
    required this.statistics,
    required this.onlineTesting,
    required this.courseBundle,
    required this.multiInstructors,
  });

  factory AddonsBean.fromJson(Map<String, dynamic> json) => _$AddonsBeanFromJson(json);

  final String? shareware;
  @JsonKey(name: 'sequential_drip_content')
  final String? sequentialDripContent;
  final String? gradebook;
  @JsonKey(name: 'live_streams')
  final String? liveStreams;
  @JsonKey(name: 'enterprise_courses')
  final String? enterpriseCourses;
  final String? assignments;
  @JsonKey(name: 'point_system')
  final String? pointSystem;
  final String? statistics;
  @JsonKey(name: 'online_testing')
  final String? onlineTesting;
  @JsonKey(name: 'course_bundle')
  final String? courseBundle;
  @JsonKey(name: 'multi_instructors')
  final String? multiInstructors;

  Map<String, dynamic> toJson() => _$AddonsBeanToJson(this);
}

@JsonSerializable()
class HomeLayoutBean {
  HomeLayoutBean({
    required this.id,
    required this.name,
    required this.enabled,
  });

  factory HomeLayoutBean.fromJson(Map<String, dynamic> json) => _$HomeLayoutBeanFromJson(json);

  final int id;
  final String name;
  final bool enabled;

  Map<String, dynamic> toJson() => _$HomeLayoutBeanToJson(this);
}

@JsonSerializable()
class OptionsBean {
  OptionsBean({
    this.subscriptions,
    this.googleOauth,
    this.facebookOauth,
    required this.logo,
    this.mainColor,
    this.mainColorHex,
    required this.secondaryColor,
    required this.secondaryColorHex,
    required this.appView,
    required this.postsCount,
    this.isFree,
  });

  factory OptionsBean.fromJson(Map<String, dynamic> json) => _$OptionsBeanFromJson(json);

  final bool? subscriptions;
  @JsonKey(name: 'google_oauth')
  final bool? googleOauth;
  @JsonKey(name: 'facebook_oauth')
  final bool? facebookOauth;
  final String? logo;
  @JsonKey(name: 'main_color')
  final ColorBean? mainColor;
  @JsonKey(name: 'main_color_hex')
  final String? mainColorHex;
  @JsonKey(name: 'secondary_color')
  final ColorBean? secondaryColor;
  @JsonKey(name: 'secondary_color_hex')
  final String? secondaryColorHex;
  @JsonKey(name: 'app_view')
  final bool appView;
  @JsonKey(name: 'posts_count')
  final num postsCount;
  @JsonKey(name: 'is_free')
  final bool? isFree;

  Map<String, dynamic> toJson() => _$OptionsBeanToJson(this);
}

@JsonSerializable()
class ColorBean {
  ColorBean({required this.r, required this.g, required this.b, required this.a});

  factory ColorBean.fromJson(Map<String, dynamic> json) => _$ColorBeanFromJson(json);

  final num r;
  final num g;
  final num b;
  final num a;

  Map<String, dynamic> toJson() => _$ColorBeanToJson(this);
}
