import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  Player._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  factory Player(
      {required String name,
      @Default({}) Map<dynamic, dynamic> rounds}) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        name: json['name'] as String,
        rounds: json['rounds'] as Map? ?? const {},
      );
}
