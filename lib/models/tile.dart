import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
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

  ///Convert Json into Tile
  factory Tile.fromJson(Map<String, dynamic> json) {
    return _$TileFromJson(json);
  }

  ///Convert Tile into Json
  Map<String, dynamic> toJson() => _$TileToJson(this);

  /// Value representing the correct position of [Tile] in a list.
  final int value;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in their
  /// correct position to complete the puzzle.
  final Position correctPosition;

  /// The current 2D [Position] of the [Tile].
  final Position currentPosition;

  /// The image data used to create the Image widget for the [Tile].
  final imglib.Image? image;

  /// The [Image] displayed in the [Tile].
  final Uint8List? displayImageBytes;

  /// Denotes if the [Tile] is the whitespace tile or not.
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
  List<Object> get props => [
        value,
        correctPosition,
        currentPosition,
        isWhitespace,
      ];
}
