// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tile _$TileFromJson(Map<String, dynamic> json) => Tile(
      value: json['value'] as int,
      correctPosition: Position.fromJson(json['correctPosition'] as Map<String, dynamic>),
      currentPosition: Position.fromJson(json['currentPosition'] as Map<String, dynamic>),
      image: const CustomImglibImageConverter().fromJson(json['image'] as Map<String, dynamic>?),
      displayImageBytes: const Uint8ListConverter().fromJson(json['displayImageBytes'] as String?),
      isWhitespace: json['isWhitespace'] as bool? ?? false,
    );

Map<String, dynamic> _$TileToJson(Tile instance) => <String, dynamic>{
      'value': instance.value,
      'correctPosition': instance.correctPosition.toJson(),
      'currentPosition': instance.currentPosition.toJson(),
      'image': const CustomImglibImageConverter().toJson(instance.image),
      'displayImageBytes': const Uint8ListConverter().toJson(instance.displayImageBytes),
      'isWhitespace': instance.isWhitespace,
    };
