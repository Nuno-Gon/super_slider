// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as imglib;
import 'package:very_good_slide_puzzle/models/json_converter/image_converter.dart';

import 'package:very_good_slide_puzzle/models/models.dart';

/// {@template mega_tile}
/// Model for a puzzle mega tile.
/// {@endtemplate}
class MegaTile extends Tile implements Equatable {
  /// {@macro mega_tile}
  MegaTile({
    this.puzzle = const Puzzle(tiles: []),
    required int value,
    required Position correctPosition,
    required Position currentPosition,
    imglib.Image? image,
    Image? displayImage,
    bool isWhitespace = false,
    this.isCompleted = false,
  }) : super(
          value: value,
          correctPosition: correctPosition,
          currentPosition: currentPosition,
          image: image,
          displayImage: displayImage,
          isWhitespace: isWhitespace,
        );

  /// Convert Json into MegaTile
  factory MegaTile.fromJson(Map<String, dynamic> json) => MegaTile(
        puzzle: json['puzzle'] == null
            ? const Puzzle(tiles: [])
            : Puzzle.fromJson(
                json['puzzle'] as Map<String, dynamic>,
              ),
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
        isCompleted: json['isCompleted'] as bool? ?? false,
      );

  /// Convert MegaTile into Json
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'value': value,
        'correctPosition': correctPosition.toJson(),
        'currentPosition': currentPosition.toJson(),
        'isWhitespace': isWhitespace,
        'isCompleted': isCompleted,
        'image': const CustomImglibImageConverter().toJson(
          image,
        ),
        'puzzle': puzzle.toJson(),
      };

  /// [Puzzle] containing the current tile arrangement.
  Puzzle puzzle;

  /// Indicates if a Mega Tile puzzle is completed.
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
      displayImage: displayImage,
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
      displayImage: displayImage,
      isCompleted: true,
    );
  }

  @override
  List<Object?> get props => [
        puzzle,
        value,
        image,
        displayImage,
        correctPosition,
        currentPosition,
        isWhitespace,
        isCompleted,
      ];
}
