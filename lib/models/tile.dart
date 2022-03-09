// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as imglib;
import 'package:very_good_slide_puzzle/models/json_converter/image_converter.dart';

import 'package:very_good_slide_puzzle/models/models.dart';

/// {@template tile}
/// Model for a puzzle tile.
/// {@endtemplate}
class Tile extends Equatable {
  /// {@macro tile}
  Tile({
    required this.value,
    required this.correctPosition,
    required this.currentPosition,
    this.image,
    this.displayImage,
    this.isWhitespace = false,
  });

  /// Convert Json into Tile
  factory Tile.fromJson(Map<String, dynamic> json) => Tile(
        value: json['value'] as int,
        correctPosition: Position.fromJson(
          json['correctPosition'] as Map<String, dynamic>,
        ),
        currentPosition: Position.fromJson(
          json['currentPosition'] as Map<String, dynamic>,
        ),
        image: const CustomImglibImageConverter().fromJson(
          json['image'] as String?,
        ),
        isWhitespace: json['isWhitespace'] as bool? ?? false,
      );

  /// Convert MegaTile into Json
  Map<String, dynamic> toJson() => <String, dynamic>{
        'value': value,
        'correctPosition': correctPosition.toJson(),
        'currentPosition': currentPosition.toJson(),
        'image': const CustomImglibImageConverter().toJson(
          image,
        ),
        'isWhitespace': isWhitespace,
      };

  /// Value representing the correct position of [Tile] in a list.
  final int value;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in their
  /// correct position to complete the puzzle.
  final Position correctPosition;

  /// The current 2D [Position] of the [Tile].
  Position currentPosition;

  /// The image data used to create the Image widget for the [Tile].
  final imglib.Image? image;

  /// The [Image] displayed in the [Tile].
  Image? displayImage;

  /// Denotes if the [Tile] is the whitespace tile or not.
  final bool isWhitespace;

  /// Create a copy of this [Tile] with updated current position.
  Tile copyWith({required Position currentPosition}) {
    return Tile(
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      image: image,
      displayImage: displayImage,
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
      displayImage: displayImage,
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
