import 'package:json_annotation/json_annotation.dart';

part 'popular_searches_response.g.dart';

@JsonSerializable()
class PopularSearchesResponse {
  PopularSearchesResponse({required this.searches});

  factory PopularSearchesResponse.fromJson(Map<String, dynamic> json) => _$PopularSearchesResponseFromJson(json);

  final List<String> searches;

  Map<String, dynamic> toJson() => _$PopularSearchesResponseToJson(this);
}

/* Response:
 {
  "searches": [
    "engine",
    "sport",
    "fashion",
    "edu",
    "music",
    "3d",
    "how to be",
    "Software development",
    "art",
    "animation"
  ]
}
*/
