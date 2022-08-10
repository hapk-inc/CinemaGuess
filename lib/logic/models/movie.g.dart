// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Movie _$$_MovieFromJson(Map<String, dynamic> json) => _$_Movie(
      lang: $enumDecode(_$LangEnumMap, json['lang']),
      mCast: json['m_cast'] as String?,
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      name: json['name'] as String,
      releasedOn: json['released_on'] as num,
      postedOn: json['posted_on'] as String,
      usersFound: (json['users_found'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      usersPlayed: (json['users_played'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_MovieToJson(_$_Movie instance) => <String, dynamic>{
      'lang': _$LangEnumMap[instance.lang]!,
      'm_cast': instance.mCast,
      'suggestions': instance.suggestions,
      'name': instance.name,
      'released_on': instance.releasedOn,
      'posted_on': instance.postedOn,
      'users_found': instance.usersFound,
      'users_played': instance.usersPlayed,
    };

const _$LangEnumMap = {
  Lang.tamil: 'tamil',
  Lang.english: 'english',
  Lang.hindi: 'hindi',
};
