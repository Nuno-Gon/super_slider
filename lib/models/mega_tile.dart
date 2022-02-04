// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
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
  List<Object> get props => [
        value,
        correctPosition,
        currentPosition,
        isWhitespace,
        isCompleted,
      ];
}
