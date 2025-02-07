import 'package:json_annotation/json_annotation.dart';
import 'package:masterstudy_app/data/models/category/category.dart';

part 'user_course.g.dart';

@JsonSerializable()
class UserCourseResponse {
  UserCourseResponse({
    required this.posts,
    required this.total,
    required this.offset,
    required this.totalPosts,
    required this.pages,
  });

  factory UserCourseResponse.fromJson(Map<String, dynamic> json) => _$UserCourseResponseFromJson(json);

  final List<PostsBean?> posts;
  final String? total;
  final num offset;
  @JsonKey(name: 'total_posts')
  final num totalPosts;
  final num pages;

  Map<String, dynamic> toJson() => _$UserCourseResponseToJson(this);
}

@JsonSerializable()
class PostsBean {
  PostsBean({
    required this.imageId,
    required this.title,
    required this.link,
    required this.image,
    required this.terms,
    required this.termsList,
    required this.views,
    required this.price,
    required this.salePrice,
    required this.postStatus,
    required this.progress,
    required this.progressLabel,
    required this.currentLessonId,
    required this.courseId,
    required this.lessonId,
    required this.startTime,
    required this.duration,
    required this.appImage,
    required this.author,
    required this.lessonType,
    required this.categoriesObject,
    required this.hash,
    required this.fromCache,
  });

  factory PostsBean.fromJson(Map<String, dynamic> json) => _$PostsBeanFromJson(json);

  @JsonKey(name: 'image_id')
  final String? imageId;
  final String? title;
  final String? link;
  final String? image;
  final List<dynamic> terms;
  @JsonKey(name: 'terms_list')
  final List<dynamic> termsList;
  final String? views;
  final String? price;
  @JsonKey(name: 'sale_price')
  final String? salePrice;
  @JsonKey(name: 'post_status')
  final PostStatusBean? postStatus;
  final String? progress;
  @JsonKey(name: 'progress_label')
  final String? progressLabel;
  @JsonKey(name: 'current_lesson_id')
  final String? currentLessonId;
  @JsonKey(name: 'course_id')
  final String? courseId;
  @JsonKey(name: 'lesson_id')
  final String? lessonId;
  @JsonKey(name: 'start_time')
  final String? startTime;
  dynamic duration;
  @JsonKey(name: 'app_image')
  dynamic appImage;
  PostAuthorBean? author;
  @JsonKey(name: 'lesson_type')
  String? lessonType;
  String? hash;
  @JsonKey(name: 'categories_object')
  List<Category?> categoriesObject;
  bool? fromCache;

  Map<String, dynamic> toJson() => _$PostsBeanToJson(this);
}

@JsonSerializable()
class PostStatusBean {
  PostStatusBean({required this.status, required this.label});

  factory PostStatusBean.fromJson(Map<String, dynamic> json) => _$PostStatusBeanFromJson(json);

  String status;
  String label;

  Map<String, dynamic> toJson() => _$PostStatusBeanToJson(this);
}

@JsonSerializable()
class PostAuthorBean {
  PostAuthorBean({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.url,
    required this.meta,
  });

  factory PostAuthorBean.fromJson(Map<String, dynamic> json) => _$PostAuthorBeanFromJson(json);

  String? id;
  String? login;
  @JsonKey(name: 'avatar_url')
  String? avatarUrl;
  String? url;
  AuthorMetaBean? meta;

  Map<String, dynamic> toJson() => _$PostAuthorBeanToJson(this);
}

@JsonSerializable()
class AuthorMetaBean {
  AuthorMetaBean({required this.type, required this.label, required this.text});

  factory AuthorMetaBean.fromJson(Map<String, dynamic> json) => _$AuthorMetaBeanFromJson(json);

  final String? type;
  final String? label;
  final String? text;

  Map<String, dynamic> toJson() => _$AuthorMetaBeanToJson(this);
}
