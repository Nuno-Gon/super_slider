import 'package:equatable/equatable.dart';

/// {@template position}
/// 2-dimensional position model.
///
/// (1, 1) is the top left corner of the board.
/// {@endtemplate}
class Position extends Equatable implements Comparable<Position> {
  /// {@macro position}
  const Position({required this.x, required this.y});

  /// Convert Json into Position
  factory Position.fromJson(Map<String, dynamic> json) => Position(
        x: json['x'] as int,
        y: json['y'] as int,
      );

  /// The x position.
  final int x;

  /// The y position.
  final int y;

  /// Convert Position into Json
  Map<String, dynamic> toJson() => <String, dynamic>{
        'x': x,
        'y': y,
      };

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
