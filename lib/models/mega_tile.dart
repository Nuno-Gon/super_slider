// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_slide_puzzle/models/json_converter/custom_imglib_image_converter.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';

part 'mega_tile.g.dart';

/// {@template mega_tile}
/// Model for a puzzle mega tile.
/// {@endtemplate}

@JsonSerializable()
@CustomImglibImageConverter()
@Uint8ListConverter()
class MegaTile extends Tile {
  /// {@macro mega_tile}
  MegaTile({
    this.puzzle = const Puzzle(tiles: []),
    required int value,
    required Position correctPosition,
    required Position currentPosition,
    Image? image,
    Uint8List? displayImageBytes,
    bool isWhitespace = false,
    this.isCompleted = false,
  }) : super(
          value: value,
          correctPosition: correctPosition,
          currentPosition: currentPosition,
          image: image,
          displayImageBytes: displayImageBytes,
          isWhitespace: isWhitespace,
        );

  ///Convert Json into MegaTile
  factory MegaTile.fromJson(Map<String, dynamic> json) => _$MegaTileFromJson(json);

  ///Convert MegaTile into Json
  Map<String, dynamic> toJson() => _$MegaTileToJson(this);

  /// [Puzzle] containing the current tile arrangement.
  @JsonValue('puzzle')
  Puzzle puzzle;

  /// Indicates if a Mega Tile puzzle is completed.
  @JsonValue('is_completed')
  bool isCompleted;

  /// Create a copy of this [MegaTile] with updated current position.
  @override
  MegaTile copyWith({required Position currentPosition}) {
    return MegaTile(
      puzzle: puzzle,
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      image: image,
      displayImageBytes: displayImageBytes,
      isWhitespace: isWhitespace,
      isCompleted: isCompleted,
    );
  }

  /// Create a copy of this [MegaTile] with finished state.
  @override
  MegaTile removeWhitespace() {
    return MegaTile(
      puzzle: puzzle,
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      image: image,
      displayImageBytes: displayImageBytes,
      isCompleted: true,
    );
  }

  @override
  List<Object> get props => [
        value,
        correctPosition,
        puzzle,
        currentPosition,
        isWhitespace,
        isCompleted,
      ];
}
