// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'movie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return _Movie.fromJson(json);
}

/// @nodoc
mixin _$Movie {
  Lang get lang => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  num get releasedOn => throw _privateConstructorUsedError;
  String get postedOn => throw _privateConstructorUsedError;
  List<String> get usersFound => throw _privateConstructorUsedError;
  List<String> get usersPlayed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MovieCopyWith<Movie> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieCopyWith<$Res> {
  factory $MovieCopyWith(Movie value, $Res Function(Movie) then) =
      _$MovieCopyWithImpl<$Res>;
  $Res call(
      {Lang lang,
      String name,
      num releasedOn,
      String postedOn,
      List<String> usersFound,
      List<String> usersPlayed});
}

/// @nodoc
class _$MovieCopyWithImpl<$Res> implements $MovieCopyWith<$Res> {
  _$MovieCopyWithImpl(this._value, this._then);

  final Movie _value;
  // ignore: unused_field
  final $Res Function(Movie) _then;

  @override
  $Res call({
    Object? lang = freezed,
    Object? name = freezed,
    Object? releasedOn = freezed,
    Object? postedOn = freezed,
    Object? usersFound = freezed,
    Object? usersPlayed = freezed,
  }) {
    return _then(_value.copyWith(
      lang: lang == freezed
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as Lang,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      releasedOn: releasedOn == freezed
          ? _value.releasedOn
          : releasedOn // ignore: cast_nullable_to_non_nullable
              as num,
      postedOn: postedOn == freezed
          ? _value.postedOn
          : postedOn // ignore: cast_nullable_to_non_nullable
              as String,
      usersFound: usersFound == freezed
          ? _value.usersFound
          : usersFound // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usersPlayed: usersPlayed == freezed
          ? _value.usersPlayed
          : usersPlayed // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$$_MovieCopyWith<$Res> implements $MovieCopyWith<$Res> {
  factory _$$_MovieCopyWith(_$_Movie value, $Res Function(_$_Movie) then) =
      __$$_MovieCopyWithImpl<$Res>;
  @override
  $Res call(
      {Lang lang,
      String name,
      num releasedOn,
      String postedOn,
      List<String> usersFound,
      List<String> usersPlayed});
}

/// @nodoc
class __$$_MovieCopyWithImpl<$Res> extends _$MovieCopyWithImpl<$Res>
    implements _$$_MovieCopyWith<$Res> {
  __$$_MovieCopyWithImpl(_$_Movie _value, $Res Function(_$_Movie) _then)
      : super(_value, (v) => _then(v as _$_Movie));

  @override
  _$_Movie get _value => super._value as _$_Movie;

  @override
  $Res call({
    Object? lang = freezed,
    Object? name = freezed,
    Object? releasedOn = freezed,
    Object? postedOn = freezed,
    Object? usersFound = freezed,
    Object? usersPlayed = freezed,
  }) {
    return _then(_$_Movie(
      lang: lang == freezed
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as Lang,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      releasedOn: releasedOn == freezed
          ? _value.releasedOn
          : releasedOn // ignore: cast_nullable_to_non_nullable
              as num,
      postedOn: postedOn == freezed
          ? _value.postedOn
          : postedOn // ignore: cast_nullable_to_non_nullable
              as String,
      usersFound: usersFound == freezed
          ? _value._usersFound
          : usersFound // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usersPlayed: usersPlayed == freezed
          ? _value._usersPlayed
          : usersPlayed // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _$_Movie implements _Movie {
  _$_Movie(
      {required this.lang,
      required this.name,
      required this.releasedOn,
      required this.postedOn,
      final List<String> usersFound = const [],
      final List<String> usersPlayed = const []})
      : _usersFound = usersFound,
        _usersPlayed = usersPlayed;

  factory _$_Movie.fromJson(Map<String, dynamic> json) =>
      _$$_MovieFromJson(json);

  @override
  final Lang lang;
  @override
  final String name;
  @override
  final num releasedOn;
  @override
  final String postedOn;
  final List<String> _usersFound;
  @override
  @JsonKey()
  List<String> get usersFound {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_usersFound);
  }

  final List<String> _usersPlayed;
  @override
  @JsonKey()
  List<String> get usersPlayed {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_usersPlayed);
  }

  @override
  String toString() {
    return 'Movie(lang: $lang, name: $name, releasedOn: $releasedOn, postedOn: $postedOn, usersFound: $usersFound, usersPlayed: $usersPlayed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Movie &&
            const DeepCollectionEquality().equals(other.lang, lang) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.releasedOn, releasedOn) &&
            const DeepCollectionEquality().equals(other.postedOn, postedOn) &&
            const DeepCollectionEquality()
                .equals(other._usersFound, _usersFound) &&
            const DeepCollectionEquality()
                .equals(other._usersPlayed, _usersPlayed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(lang),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(releasedOn),
      const DeepCollectionEquality().hash(postedOn),
      const DeepCollectionEquality().hash(_usersFound),
      const DeepCollectionEquality().hash(_usersPlayed));

  @JsonKey(ignore: true)
  @override
  _$$_MovieCopyWith<_$_Movie> get copyWith =>
      __$$_MovieCopyWithImpl<_$_Movie>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MovieToJson(this);
  }
}

abstract class _Movie implements Movie {
  factory _Movie(
      {required final Lang lang,
      required final String name,
      required final num releasedOn,
      required final String postedOn,
      final List<String> usersFound,
      final List<String> usersPlayed}) = _$_Movie;

  factory _Movie.fromJson(Map<String, dynamic> json) = _$_Movie.fromJson;

  @override
  Lang get lang => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  num get releasedOn => throw _privateConstructorUsedError;
  @override
  String get postedOn => throw _privateConstructorUsedError;
  @override
  List<String> get usersFound => throw _privateConstructorUsedError;
  @override
  List<String> get usersPlayed => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_MovieCopyWith<_$_Movie> get copyWith =>
      throw _privateConstructorUsedError;
}
