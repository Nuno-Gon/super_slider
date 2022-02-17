import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import 'package:image/image.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_slide_puzzle/models/json_converter/custom_imglib_image_converter.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

part 'tile.g.dart';

/// {@template tile}
/// Model for a puzzle tile.
/// {@endtemplate}

@JsonSerializable()
@CustomImglibImageConverter()
@Uint8ListConverter()
class Tile extends Equatable {
  /// {@macro tile}
  const Tile({
    required this.value,
    required this.correctPosition,
    required this.currentPosition,
    this.image,
    this.displayImageBytes,
    this.isWhitespace = false,
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$TileFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Tile.
  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TileToJson`.
  Map<String, dynamic> toJson() => _$TileToJson(this);

  /// Value representing the correct position of [Tile] in a list.
  @JsonValue('value')
  final int value;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in their
  /// correct position to complete the puzzle.
  @JsonValue('correct_position')
  final Position correctPosition;

  /// The current 2D [Position] of the [Tile].
  @JsonValue('current_position')
  final Position currentPosition;

  /// The image data used to create the Image widget for the [Tile].
  @JsonValue('image')
  final Image? image;

  /// The [Image] displayed in the [Tile].
  @JsonValue('displayImageBytes')
  final Uint8List? displayImageBytes;

  /// Denotes if the [Tile] is the whitespace tile or not.
  @JsonValue('is_whitespace')
  final bool isWhitespace;

  /// Create a copy of this [Tile] with updated current position.
  Tile copyWith({required Position currentPosition}) {
    return Tile(
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      image: image,
      displayImageBytes: displayImageBytes,
      isWhitespace: isWhitespace,
    );
  }

  /// Create a copy of this [Tile] with finished state.
  Tile removeWhitespace() {
    return Tile(
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      image: image,
      displayImageBytes: displayImageBytes,
    );
  }

  @override
  List<Object?> get props => [
        value,
        image,
        displayImageBytes,
        correctPosition,
        currentPosition,
        isWhitespace,
      ];
}
