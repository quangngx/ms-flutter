import 'package:json_annotation/json_annotation.dart';

part 'curriculum.g.dart';

@JsonSerializable()
class CurriculumResponse {
  factory CurriculumResponse.fromJson(Map<String, dynamic> json) => _$CurriculumResponseFromJson(json);

  CurriculumResponse({
    this.currentLessonId,
    required this.progressPercent,
    this.lessonType,
    required this.sections,
    required this.materials,
    required this.scorm,
  });

  @JsonKey(name: 'current_lesson_id')
  final String? currentLessonId;
  @JsonKey(name: 'progress_percent')
  final String progressPercent;
  @JsonKey(name: 'lesson_type')
  final String? lessonType;
  final List<SectionItem?> sections;
  final List<MaterialItem> materials;

  // TODO: Find out the type
  final dynamic scorm;

  Map<String, dynamic> toJson() => _$CurriculumResponseToJson(this);
}

@JsonSerializable()
class SectionItem {
  SectionItem({
    required this.id,
    required this.title,
    required this.order,
    required this.sectionItems,
  });

  factory SectionItem.fromJson(Map<String, dynamic> json) => _$SectionItemFromJson(json);

  final int id;
  final String? title;
  final int order;
  final List<SectionItemsBean>? sectionItems;

  Map<String, dynamic> toJson() => _$SectionItemToJson(this);
}

@JsonSerializable()
class MaterialItem {
  factory MaterialItem.fromJson(Map<String, dynamic> json) => _$MaterialItemFromJson(json);

  MaterialItem({
    required this.id,
    required this.title,
    required this.postId,
    required this.postType,
    required this.lessonType,
    required this.sectionId,
    required this.order,
    required this.type,
    this.quizInfo,
    required this.locked,
    required this.completed,
    required this.hasPreview,
    this.duration,
    this.questions,
  });

  final int id;
  final String title;
  @JsonKey(name: 'post_id')
  final int postId;
  @JsonKey(name: 'post_type')
  final String postType;
  @JsonKey(name: 'lesson_type')
  final String? lessonType;
  @JsonKey(name: 'section_id')
  final int sectionId;
  final int order;
  final String type;
  @JsonKey(name: 'quiz_info')
  final dynamic quizInfo;
  final bool locked;
  final bool completed;
  @JsonKey(name: 'has_preview')
  final bool hasPreview;

  // TODO: Find out the type
  final dynamic duration;

  // TODO: Find out the type
  final dynamic questions;

  Map<String, dynamic> toJson() => _$MaterialItemToJson(this);
}

@JsonSerializable()
class SectionItemsBean {
  SectionItemsBean({
    required this.itemId,
    required this.title,
    required this.type,
    required this.quizInfo,
    required this.locked,
    required this.completed,
    required this.hasPreview,
    required this.lessonId,
    this.duration,
    this.questions,
  });

  factory SectionItemsBean.fromJson(Map<String, dynamic> json) => _$SectionItemsBeanFromJson(json);

  @JsonKey(name: 'item_id')
  final int? itemId;
  final String? title;
  final String? type;
  @JsonKey(name: 'quiz_info')
  final dynamic quizInfo;
  final bool? locked;
  final bool? completed;
  @JsonKey(name: 'lessonId')
  final dynamic lessonId;
  @JsonKey(name: 'has_preview')
  final bool? hasPreview;
  final String? duration;
  final String? questions;

  Map<String, dynamic> toJson() => _$SectionItemsBeanToJson(this);
}
