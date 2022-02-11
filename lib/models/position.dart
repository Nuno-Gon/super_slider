import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'position.g.dart';

/// {@template position}
/// 2-dimensional position model.
///
/// (1, 1) is the top left corner of the board.
/// {@endtemplate}

@JsonSerializable()
class Position extends Equatable implements Comparable<Position> {
  /// {@macro position}
  const Position({
    this.x = 0,
    this.y = 0,
  });

  ///Convert Json into Position
  factory Position.fromJson(Map<String, dynamic> json) {
    return _$PositionFromJson(json);
  }

  ///Convert Position into Json
  Map<String, dynamic> toJson() => _$PositionToJson(this);

  /// The x position.
  final int x;

  /// The y position.
  final int y;

  @override
  List<Object> get props => [x, y];

  @override
  int compareTo(Position other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
