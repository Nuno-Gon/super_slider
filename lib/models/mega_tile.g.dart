// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mega_tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MegaTile _$MegaTileFromJson(Map<String, dynamic> json) => MegaTile(
      puzzle: json['puzzle'] == null
          ? const Puzzle(tiles: [])
          : Puzzle.fromJson(json['puzzle'] as Map<String, dynamic>),
      value: json['value'] as int,
      correctPosition:
          Position.fromJson(json['correctPosition'] as Map<String, dynamic>),
      currentPosition:
          Position.fromJson(json['currentPosition'] as Map<String, dynamic>),
      image: const CustomImglibImageConverter()
          .fromJson(json['image'] as Map<String, dynamic>?),
      isWhitespace: json['isWhitespace'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$MegaTileToJson(MegaTile instance) => <String, dynamic>{
      'value': instance.value,
      'correctPosition': instance.correctPosition.toJson(),
      'currentPosition': instance.currentPosition.toJson(),
      'isWhitespace': instance.isWhitespace,
      'isCompleted': instance.isCompleted,
      'image': const CustomImglibImageConverter().toJson(instance.image),
      'puzzle': instance.puzzle.toJson(),
    };
