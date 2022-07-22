import 'package:freezed_annotation/freezed_annotation.dart';

import 'language.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
class Movie with _$Movie {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  factory Movie({
    required Lang lang,
    String? mCast,
    @Default([]) List<String> suggestions,
    required String name,
    required num releasedOn,
    required String postedOn,
    @Default([]) List<String> usersFound,
    @Default([]) List<String> usersPlayed,
  }) = _Movie;

  factory Movie.fromJson(Map<String, Object?> json) => _$MovieFromJson(json);
}
