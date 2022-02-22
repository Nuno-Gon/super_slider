// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:very_good_slide_puzzle/datasource/firebase_service.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/utils/utils.dart';

part 'puzzle_event.dart';

part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._size, {this.imageUrl, this.random})
      : super(
          const PuzzleState(),
        ) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<TileDoubleTapped>(_onTileDoubleTapped);
    on<ActiveTileReset>(_onActiveTileReset);
    on<PuzzleReset>(_onPuzzleReset);
    on<PuzzleImport>(_onPuzzleImport);
    on<PuzzleExport>(_onPuzzleExport);
  }

  final int _size;

  final String? imageUrl;
  final Random? random;

  Future<void> _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) async {
    late Puzzle puzzle;
    await Future<void>.delayed(const Duration(seconds: 1), () async {
      puzzle = await _generatePuzzle(_size, shuffle: event.shufflePuzzle);
    });

    if (puzzle.tiles.isEmpty) {
      emit(
        const PuzzleState(
          puzzleStatus: PuzzleStatus.imageError,
        ),
      );
    } else {
      emit(
        PuzzleState(
          puzzle: puzzle.sort(),
          numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
        ),
      );
    }
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete()) {
          final whitespaceTile = puzzle.getWhitespaceTile() as MegaTile;
          final index = puzzle.tiles.indexOf(whitespaceTile);
          puzzle.tiles[index] = whitespaceTile.removeWhitespace();

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

  void _onTileDoubleTapped(TileDoubleTapped event, Emitter<PuzzleState> emit) {
    final doubleTappedTile = event.tile;
    emit(
      state.copyWith(
        activeTile: doubleTappedTile,
      ),
    );
  }

  void _onActiveTileReset(ActiveTileReset event, Emitter<PuzzleState> emit) {
    emit(
      state.resetActiveTile(),
    );
  }

  FutureOr<void> _onPuzzleImport(
    // TODO(JR): validate
    PuzzleImport event,
    Emitter<PuzzleState> emit,
  ) async {
    emit(
      state.copyWith(multiplayerStatus: MultiplayerStatus.loading),
    );

    ///TODO(WARRIOR): CHECK WHY IMPORT NOT WORKING.
    await FirebaseService.instance.getPuzzle(
      id: event.puzzleCode,
      onSuccess: (puzzle) {
        emit(
          PuzzleState(
            puzzle: puzzle,
            multiplayerStatus: MultiplayerStatus.successImport,
          ),
        );
      },
      onError: () => emit(
        state.copyWith(multiplayerStatus: MultiplayerStatus.errorImport),
      ),
    );
  }

  FutureOr<void> _onPuzzleExport(
    PuzzleExport event,
    Emitter<PuzzleState> emit,
  ) async {
    emit(
      state.copyWith(multiplayerStatus: MultiplayerStatus.loading),
    );

    final id = generateID();
    final data = getJsonUint8List(
      jsonEncode(state.puzzle),
    );

    final downloadUrl = await FirebaseService.instance.uploadToStorage(
      puzzleCode: id,
      data: data,
    );

    if (downloadUrl == null) {
      emit(
        state.copyWith(multiplayerStatus: MultiplayerStatus.errorExport),
      );
      return;
    }

    await FirebaseService.instance.addToCollection(
      collection: 'puzzle',
      data: <String, dynamic>{
        'id': 'QUACK-$id',
        'content': downloadUrl,
      },
      onSuccess: () => emit(
        state.copyWith(
          multiplayerStatus: MultiplayerStatus.successExport,
          data: id,
        ),
      ),
      onError: () => emit(
        state.copyWith(multiplayerStatus: MultiplayerStatus.errorExport),
      ),
    );
  }

  Future<void> _onPuzzleReset(
    PuzzleReset event,
    Emitter<PuzzleState> emit,
  ) async {
    emit(
      const PuzzleState(),
    );
    late Puzzle puzzle;
    await Future<void>.delayed(const Duration(seconds: 1), () async {
      puzzle = await _generatePuzzle(_size);
    });

    if (puzzle.tiles.isEmpty) {
      emit(
        const PuzzleState(
          puzzleStatus: PuzzleStatus.imageError,
        ),
      );
    } else {
      emit(
        PuzzleState(
          puzzle: puzzle.sort(),
          numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
        ),
      );
    }
  }

  /// Build a randomized, solvable puzzle of the given size.
  Future<Puzzle> _generatePuzzle(int size, {bool shuffle = true}) async {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);
    final dividedImage = await splitImage(imageUrl);

    if (dividedImage.isEmpty) {
      return const Puzzle(tiles: []);
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
        );
        puzzle = Puzzle(tiles: tiles);
      }
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<MegaTile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
    List<Image> dividedImage,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          MegaTile(
            value: i,
            image: dividedImage[i - 1],
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          MegaTile(
            value: i,
            image: dividedImage[i - 1],
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }

  Future<List<Image>> splitImage(String? imageUrl) async {
    final horizontalPieceCount = _size;
    final verticalPieceCount = _size;
    final byteData = await getByteDataOfImage(imageUrl);
    final convertedData = List<int>.from(byteData);

    var image = decodeImage(convertedData);
    if (image == null) {
      return <Image>[];
    }

    // Cut the image into a square
    if (image.width != image.height) {
      final cutSize = image.width < image.height ? image.width : image.height;
      image = copyCrop(image, 0, 0, cutSize, cutSize);
    }

    final xLength = (image.width / horizontalPieceCount).round();
    final yLength = (image.height / verticalPieceCount).round();
    final pieceList = <Image>[];

    for (var y = 0; y < verticalPieceCount; y++) {
      for (var x = 0; x < horizontalPieceCount; x++) {
        pieceList.add(
          copyCrop(image, x * xLength, y * yLength, xLength, yLength),
        );
      }
    }

    return pieceList;
  }

  Future<Uint8List> getByteDataOfImage(String? imageUrl) async {
    late Uint8List byteData;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse(imageUrl),
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Credentials': 'true',
          },
        );

        byteData = response.bodyBytes;
      } on Exception catch (_) {
        byteData = Uint8List(6);
      }
    } else {
      final curatedImages = [
        'assets/images/square_life.jpg',
        'assets/images/square_flyer.jpeg',
        'assets/images/square_png.png',
      ];
      final randomPick = Random().nextInt(curatedImages.length);
      byteData = (await rootBundle.load(
        curatedImages[randomPick],
      ))
          .buffer
          .asUint8List();
    }

    return byteData;
  }
}
