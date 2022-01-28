import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/settings/settings.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SimplePuzzleShuffleButton(),
          medium: (_, child) => const SimplePuzzleShuffleButton(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => SizedBox(
          width: 184,
          height: 118,
          child: Image.asset(
            'assets/images/simple_dash_small.png',
            key: const Key('simple_puzzle_dash_small'),
          ),
        ),
        medium: (_, __) => SizedBox(
          width: 380.44,
          height: 214,
          child: Image.asset(
            'assets/images/simple_dash_medium.png',
            key: const Key('simple_puzzle_dash_medium'),
          ),
        ),
        large: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 53),
          child: SizedBox(
            width: 568.99,
            height: 320,
            child: Image.asset(
              'assets/images/simple_dash_large.png',
              key: const Key('simple_puzzle_dash_large'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(
    int size,
    List<Widget> tiles,
    PuzzleType puzzleType,
    SettingsState settings,
  ) {
    final isMegaPuzzle = puzzleType == PuzzleType.mega;

    return Column(
      children: [
        if (isMegaPuzzle)
          const ResponsiveGap(
            small: 32,
            medium: 48,
            large: 96,
          ),
        ResponsiveLayoutBuilder(
          // TODO(JR): simplify
          small: (_, __) => SizedBox.square(
            dimension: isMegaPuzzle
                ? _BoardSize.small
                : _miniBoardSize(
                    boardSize: _BoardSize.small,
                    gapSize: 4,
                    size: settings.megaPuzzleSize,
                  ),
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 4,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: isMegaPuzzle
                ? _BoardSize.medium
                : _miniBoardSize(
                    boardSize: _BoardSize.medium,
                    gapSize: 2,
                    size: settings.megaPuzzleSize,
                  ),
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: isMegaPuzzle
                ? _BoardSize.large
                : _miniBoardSize(
                    boardSize: _BoardSize.large,
                    gapSize: 2,
                    size: settings.megaPuzzleSize,
                  ),
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
        if (isMegaPuzzle)
          const ResponsiveGap(
            large: 96,
          ),
      ],
    );
  }

  @override
  Widget megaTileBuilder(MegaTile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleMegaTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleMegaTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        state: state,
      ),
      large: (_, __) => SimplePuzzleMegaTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        state: state,
      ),
    );
  }

  @override
  Widget miniTileBuilder(Tile tile, MiniPuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleMiniTile(
        key: Key('simple_puzzle_mini_tile_${tile.value}_small'),
        tile: tile,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleMiniTile(
        key: Key('simple_puzzle_mini_tile_${tile.value}_medium'),
        tile: tile,
        state: state,
      ),
      large: (_, __) => SimplePuzzleMiniTile(
        key: Key('simple_puzzle_mini_tile_${tile.value}_large'),
        tile: tile,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];

  double _miniBoardSize({
    required double boardSize,
    required int gapSize,
    required int size,
  }) {
    final numberOfGaps = size - 1;
    return (boardSize - (numberOfGaps * gapSize)) / size;
  }
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
        ),
        const PuzzleName(),
        const ResponsiveGap(large: 16),
        SimplePuzzleTitle(
          status: state.puzzleStatus,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        NumberOfMovesAndTilesLeft(
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: state.numberOfTilesLeft,
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleShuffleButton(),
        ),
      ],
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      title: status == PuzzleStatus.complete
          ? context.l10n.puzzleCompleted
          : context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 2,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => context.read<PuzzleBloc>().add(
            const ActiveTileReset(),
          ),
      child: Container(
        color: Colors.green.withOpacity(size == 3 ? 0 : 0.3), // TODO(JR): temp
        child: GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: size,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          children: tiles,
        ),
      ),
    );
  }
}

/// {@template simple_puzzle_mega_tile}
/// Displays the puzzle mega tiles associated with [tile]
/// based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleMegaTile extends StatelessWidget {
  /// {@macro simple_puzzle_mega_tile}
  const SimplePuzzleMegaTile({
    Key? key,
    required this.tile,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final MegaTile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final settings = context.select((SettingsBloc bloc) => bloc.state);

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = theme is SimpleTheme;

    /// Check if the player isn't using a Mini Puzzle
    final allTilesDeactivated = state.activeTile == null;

    return Stack(
      children: [
        BlocProvider(
          key: ValueKey(tile),
          create: (context) => MiniPuzzleBloc(
            settings.miniPuzzleSize,
            image: tile.image,
            megaTile: tile,
          )..add(
              MiniPuzzleInitialized(
                shufflePuzzle: shufflePuzzle,
              ),
            ),
          child: const MiniPuzzle(
            key: Key('mini_puzzle_view_puzzle'),
          ),
        ),
        if (state.activeTile != tile)
          Positioned.fill(
            child: GestureDetector(
              onTap: state.puzzleStatus == PuzzleStatus.incomplete &&
                      allTilesDeactivated
                  ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
                  : null,
              onDoubleTap: () =>
                  context.read<PuzzleBloc>().add(TileDoubleTapped(tile)),
              onLongPress: () {
                // TODO(JR): Here just for the purpose of testability; remove
                context.read<SettingsBloc>().add(
                      const SettingsUpdated(
                        5,
                        4,
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Anas_platyrhynchos_male_female_quadrat.jpg/1200px-Anas_platyrhynchos_male_female_quadrat.jpg',
                      ),
                    );
              },
              child: Container(
                // TODO(JR): temp, for aux visual aid
                color: Colors.red.shade50.withOpacity(0.5),
                // child: Center(
                //   child: Text(tile.value.toString()),
                // ),
                child: Opacity(
                  opacity: 0.6,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: tile.displayImage,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// {@template simple_puzzle_mini_tile}
/// Displays the puzzle mini tile associated with [tile]
/// based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleMiniTile extends StatelessWidget {
  /// {@macro simple_puzzle_mini_tile}
  const SimplePuzzleMiniTile({
    Key? key,
    required this.tile,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The state of the puzzle.
  final MiniPuzzleState state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state.puzzleStatus == PuzzleStatus.incomplete
          ? () => context.read<MiniPuzzleBloc>().add(MiniTileTapped(tile))
          : null,
      child: Container(
        // TODO(JR): temp, for aux visual aid
        color: Colors.red,
        // child: Center(
        //   child: Text(tile.value.toString()),
        // ),
        child: FittedBox(
          fit: BoxFit.fill,
          child: tile.displayImage,
        ),
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleShuffle),
        ],
      ),
    );
  }
}
