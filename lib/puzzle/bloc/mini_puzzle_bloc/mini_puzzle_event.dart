// ignore_for_file: public_member_api_docs

part of 'mini_puzzle_bloc.dart';

abstract class MiniPuzzleEvent extends Equatable {
  const MiniPuzzleEvent();

  @override
  List<Object> get props => [];
}

class MiniPuzzleInitialized extends MiniPuzzleEvent {
  const MiniPuzzleInitialized({required this.shufflePuzzle});

  final bool shufflePuzzle;

  @override
  List<Object> get props => [shufflePuzzle];
}

class MiniTileTapped extends MiniPuzzleEvent {
  const MiniTileTapped(this.tile);

  final Tile tile;

  @override
  List<Object> get props => [tile];
}
