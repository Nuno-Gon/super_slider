// ignore_for_file: public_member_api_docs

part of 'puzzle_bloc.dart';

enum PuzzleStatus {
  incomplete,
  complete,
  imageError,
}

enum TileMovementStatus {
  nothingTapped,
  cannotBeMoved,
  moved,
}

enum SharingStatus {
  loading,
  initExport,
  initImport,
  successExport,
  successImport,
  errorExport,
  errorImport,
}

class PuzzleState extends Equatable {
  const PuzzleState({
    this.puzzle = const Puzzle(tiles: []),
    this.puzzleStatus = PuzzleStatus.incomplete,
    this.tileMovementStatus = TileMovementStatus.nothingTapped,
    this.numberOfCorrectTiles = 0,
    this.numberOfMoves = 0,
    this.lastTappedTile,
    this.activeTile,
    this.sharingStatus,
    this.isSharingSuper,
    this.data,
  });

  /// [Puzzle] containing the current tile arrangement.
  final Puzzle puzzle;

  /// Status indicating the current state of the puzzle.
  final PuzzleStatus puzzleStatus;

  /// Status indicating if a [Tile] was moved or why a [Tile] was not moved.
  final TileMovementStatus tileMovementStatus;

  /// Represents the last tapped tile of the puzzle.
  ///
  /// The value is `null` if the user has not interacted with
  /// the puzzle yet.
  final Tile? lastTappedTile;

  /// Represents the active tile of the puzzle, if any.
  ///
  /// The value is `null` if there are no active tiles.
  final Tile? activeTile;

  /// Number of tiles currently in their correct position.
  final int numberOfCorrectTiles;

  /// Total number of mini puzzles, plus the main puzzle itself, completed.
  int get completedPuzzles {
    final completedMiniPuzzles = puzzle.tiles
        .where((element) => (element as MegaTile).isCompleted)
        .length;
    final incrementCompletionValue = puzzle.isComplete() ? 1 : 0;
    return completedMiniPuzzles + incrementCompletionValue;
  }

  /// Number of tiles currently not in their correct position.
  int get numberOfTilesLeft => puzzle.tiles.length - numberOfCorrectTiles - 1;

  /// Number representing how many moves have been made on the current puzzle.
  ///
  /// The number of moves is not always the same as the total number of tiles
  /// moved. If a row/column of 2+ tiles are moved from one tap, one move is
  /// added.
  final int numberOfMoves;

  /// Status of the sharing operation
  final SharingStatus? sharingStatus;

  /// Shows if the imported puzzle was Super type
  final bool? isSharingSuper;

  /// Used to pass any data that is needed
  final Object? data;

  PuzzleState copyWith({
    Puzzle? puzzle,
    PuzzleStatus? puzzleStatus,
    TileMovementStatus? tileMovementStatus,
    int? numberOfCorrectTiles,
    int? numberOfMoves,
    Tile? lastTappedTile,
    Tile? activeTile,
    SharingStatus? sharingStatus,
    bool? isSharingSuper,
    Object? data,
  }) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle.sort(),
      puzzleStatus: puzzleStatus ?? this.puzzleStatus,
      tileMovementStatus: tileMovementStatus ?? this.tileMovementStatus,
      numberOfCorrectTiles: numberOfCorrectTiles ?? this.numberOfCorrectTiles,
      numberOfMoves: numberOfMoves ?? this.numberOfMoves,
      lastTappedTile: lastTappedTile ?? this.lastTappedTile,
      activeTile: activeTile ?? this.activeTile,
      sharingStatus: sharingStatus,
      isSharingSuper: isSharingSuper ?? this.isSharingSuper,
      data: data,
    );
  }

  PuzzleState resetActiveTile({
    Puzzle? puzzle,
    PuzzleStatus? puzzleStatus,
    TileMovementStatus? tileMovementStatus,
    int? numberOfCorrectTiles,
    int? numberOfMoves,
    Tile? lastTappedTile,
    bool? isSharingSuper,
  }) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle.sort(),
      puzzleStatus: puzzleStatus ?? this.puzzleStatus,
      tileMovementStatus: tileMovementStatus ?? this.tileMovementStatus,
      numberOfCorrectTiles: numberOfCorrectTiles ?? this.numberOfCorrectTiles,
      numberOfMoves: numberOfMoves ?? this.numberOfMoves,
      lastTappedTile: lastTappedTile ?? this.lastTappedTile,
      isSharingSuper: isSharingSuper ?? this.isSharingSuper,
    );
  }

  @override
  List<Object?> get props => [
        puzzle,
        puzzleStatus,
        tileMovementStatus,
        numberOfCorrectTiles,
        numberOfMoves,
        lastTappedTile,
        activeTile,
        sharingStatus,
        isSharingSuper,
      ];
}
