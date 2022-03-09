// ignore_for_file: public_member_api_docs

import 'dart:math';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';

part 'mini_puzzle_event.dart';

part 'mini_puzzle_state.dart';

class MiniPuzzleBloc extends Bloc<MiniPuzzleEvent, MiniPuzzleState> {
  MiniPuzzleBloc(this._size, {this.megaTile, this.image, this.random})
      : super(
          const MiniPuzzleState(),
        ) {
    on<MiniPuzzleInitialized>(_onPuzzleInitialized);
    on<MiniTileTapped>(_onTileTapped);
  }

  final int _size;

  final MegaTile? megaTile;
  final imglib.Image? image;
  final Random? random;

  void _onPuzzleInitialized(
    MiniPuzzleInitialized event,
    Emitter<MiniPuzzleState> emit,
  ) {
    final hasPuzzleGenerated = megaTile!.puzzle.tiles.isNotEmpty;
    final puzzle = hasPuzzleGenerated
        ? megaTile!.puzzle
        : _generatePuzzle(
            _size,
            shuffle: event.shufflePuzzle,
          );

    if (!hasPuzzleGenerated) {
      megaTile!.puzzle = puzzle;
    }

    emit(
      MiniPuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onTileTapped(MiniTileTapped event, Emitter<MiniPuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        megaTile!.puzzle = puzzle;
        if (puzzle.isComplete()) {
          final whitespaceTile = puzzle.getWhitespaceTile();
          final index = puzzle.tiles.indexOf(whitespaceTile);
          puzzle.tiles[index] = whitespaceTile.removeWhitespace();
          megaTile!.isCompleted = true;
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.tiles.length,
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);
    final dividedImage = splitImage(
      image: image,
      horizontalPieceCount: size,
      verticalPieceCount: size,
    );

// Create List with converted images ready to display
    final displayReadyImages = <Image>[];
    for (final img in dividedImage) {
      displayReadyImages.add(
        convertImage(img),
      );
    }
    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    if (shuffle) {
      // Randomize only the current tile positions.
      currentPositions.shuffle(random);
    }

    var tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
      dividedImage,
      displayReadyImages,
    );

    var puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      // Assign the tiles new current positions until the puzzle is solvable and
      // zero tiles are in their correct position.
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPositions.shuffle(random);
        tiles = _getTileListFromPositions(
          size,
          correctPositions,
          currentPositions,
          dividedImage,
          displayReadyImages,
        );
        puzzle = Puzzle(tiles: tiles);
      }
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
    List<imglib.Image> dividedImage,
    List<Image> displayReadyImages,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            image: dividedImage[i - 1],
            displayImage: displayReadyImages[i - 1],
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            image: dividedImage[i - 1],
            displayImage: displayReadyImages[i - 1],
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }

  List<imglib.Image> splitImage({
    required imglib.Image? image,
    required int horizontalPieceCount,
    required int verticalPieceCount,
  }) {
    if (image == null) return [];

    final xLength = (image.width / horizontalPieceCount).round();
    final yLength = (image.height / verticalPieceCount).round();
    final pieceList = <imglib.Image>[];

    for (var y = 0; y < verticalPieceCount; y++) {
      for (var x = 0; x < horizontalPieceCount; x++) {
        pieceList.add(
          imglib.copyCrop(image, x * xLength, y * yLength, xLength, yLength),
        );
      }
    }

    return pieceList;
  }

  Image convertImage(imglib.Image image) {
    final convertedPiece = Uint8List.fromList(
      imglib.encodeJpg(
        image,
      ),
    );
    return Image.memory(convertedPiece);
  }
}
