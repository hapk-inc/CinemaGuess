// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return _Player.fromJson(json);
}

/// @nodoc
mixin _$Player {
  String get name => throw _privateConstructorUsedError;
  Map<dynamic, dynamic> get rounds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayerCopyWith<Player> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCopyWith<$Res> {
  factory $PlayerCopyWith(Player value, $Res Function(Player) then) =
      _$PlayerCopyWithImpl<$Res>;
  $Res call({String name, Map<dynamic, dynamic> rounds});
}

/// @nodoc
class _$PlayerCopyWithImpl<$Res> implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  final Player _value;
  // ignore: unused_field
  final $Res Function(Player) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? rounds = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rounds: rounds == freezed
          ? _value.rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>,
    ));
  }
}

/// @nodoc
abstract class _$$_PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$_PlayerCopyWith(_$_Player value, $Res Function(_$_Player) then) =
      __$$_PlayerCopyWithImpl<$Res>;
  @override
  $Res call({String name, Map<dynamic, dynamic> rounds});
}

/// @nodoc
class __$$_PlayerCopyWithImpl<$Res> extends _$PlayerCopyWithImpl<$Res>
    implements _$$_PlayerCopyWith<$Res> {
  __$$_PlayerCopyWithImpl(_$_Player _value, $Res Function(_$_Player) _then)
      : super(_value, (v) => _then(v as _$_Player));

  @override
  _$_Player get _value => super._value as _$_Player;

  @override
  $Res call({
    Object? name = freezed,
    Object? rounds = freezed,
  }) {
    return _then(_$_Player(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rounds: rounds == freezed
          ? _value._rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _$_Player extends _Player {
  _$_Player({required this.name, final Map<dynamic, dynamic> rounds = const {}})
      : _rounds = rounds,
        super._();

  factory _$_Player.fromJson(Map<String, dynamic> json) =>
      _$$_PlayerFromJson(json);

  @override
  final String name;
  final Map<dynamic, dynamic> _rounds;
  @override
  @JsonKey()
  Map<dynamic, dynamic> get rounds {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rounds);
  }

  @override
  String toString() {
    return 'Player(name: $name, rounds: $rounds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Player &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other._rounds, _rounds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(_rounds));

  @JsonKey(ignore: true)
  @override
  _$$_PlayerCopyWith<_$_Player> get copyWith =>
      __$$_PlayerCopyWithImpl<_$_Player>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PlayerToJson(
      this,
    );
  }
}

abstract class _Player extends Player {
  factory _Player(
      {required final String name,
      final Map<dynamic, dynamic> rounds}) = _$_Player;
  _Player._() : super._();

  factory _Player.fromJson(Map<String, dynamic> json) = _$_Player.fromJson;

  @override
  String get name;
  @override
  Map<dynamic, dynamic> get rounds;
  @override
  @JsonKey(ignore: true)
  _$$_PlayerCopyWith<_$_Player> get copyWith =>
      throw _privateConstructorUsedError;
}
