// ignore_for_file: public_member_api_docs

part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized({required this.shufflePuzzle});

  final bool shufflePuzzle;

  @override
  List<Object> get props => [shufflePuzzle];
}

class TileTapped extends PuzzleEvent {
  const TileTapped(this.tile);

  final Tile tile;

  @override
  List<Object> get props => [tile];
}

class TileDoubleTapped extends PuzzleEvent {
  const TileDoubleTapped(this.tile);

  final Tile tile;

  @override
  List<Object> get props => [tile];
}

class ActiveTileReset extends PuzzleEvent {
  const ActiveTileReset();
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();
}

class PuzzleImport extends PuzzleEvent {
  const PuzzleImport(this.puzzleCode);
  final String puzzleCode;
}

class PuzzleExport extends PuzzleEvent {
  const PuzzleExport();
}
