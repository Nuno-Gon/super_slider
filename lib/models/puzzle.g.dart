// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Puzzle _$PuzzleFromJson(Map<String, dynamic> json, {required bool isMega}) => Puzzle(
      tiles: (json['tiles'] as List<dynamic>?)?.map((e) {
            if (isMega) {
              return MegaTile.fromJson(e as Map<String, dynamic>);
            }
            return Tile.fromJson(e as Map<String, dynamic>);
          }).toList() ??
          const [],
    );

Map<String, dynamic> _$PuzzleToJson(Puzzle instance) => <String, dynamic>{
      'tiles': instance.tiles.map((e) {
        if (e is MegaTile) {
          return e.toJson();
        }
        return e.toJson();
      }).toList(),
    };
