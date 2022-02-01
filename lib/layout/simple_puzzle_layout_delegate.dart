import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

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
  Widget boardBuilder(int size, List<Widget> tiles, PuzzleType puzzleType) {
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
          small: (_, __) => SizedBox.square(
            dimension: isMegaPuzzle ? _BoardSize.small : _MiniBoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: isMegaPuzzle ? _BoardSize.medium : _MiniBoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: isMegaPuzzle ? _BoardSize.large : _MiniBoardSize.large,
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
  Widget megaTileBuilder(Tile tile, PuzzleState state) {
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
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleMiniTile(
        key: Key('simple_puzzle_mini_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleMiniTile(
        key: Key('simple_puzzle_mini_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
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

abstract class _MiniBoardSize {
  static double small = 100; // TODO(JR): make it dynamic
  static double medium = 134;
  static double large = 150;
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
    this.spacing = 8,
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
        color: Colors.green.withOpacity(size == 3 ? 0 : 1), // TODO(JR): temp
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

abstract class _TileFontSize {
  // TODO(JR): to be deleted
  static double small = 6;
  static double medium = 8;
  static double large = 10;
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
  final Tile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = theme is SimpleTheme;

    /// Check if the player isn't using a Mini Puzzle
    final allTilesDeactivated = state.activeTile == null;

    return Stack(
      children: [
        BlocProvider(
          create: (context) => MiniPuzzleBloc(4)
            ..add(
              MiniPuzzleInitialized(
                shufflePuzzle: shufflePuzzle,
              ),
            ),
          child: const MiniPuzzle(
            key: Key('mini_puzzle_view_puzzle'),
          ),
        ),
        if (state.activeTile != tile)
          GestureDetector(
            onTap: state.puzzleStatus == PuzzleStatus.incomplete &&
                    allTilesDeactivated
                ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
                : null,
            onDoubleTap: () {
              context.read<PuzzleBloc>().add(TileDoubleTapped(tile));
            },
            child: Container(
              // TODO(JR): temp, for aux visual aid
              color: Colors.red.shade50.withOpacity(0.5),
              child: Center(
                child: Text(tile.value.toString()),
              ),
            ),
          ),
      ],
    );
  }
}

/// {@template simple_puzzle_mini_tile}
/// Displays the puzzle mini tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleMiniTile extends StatelessWidget {
  /// {@macro simple_puzzle_mini_tile}
  const SimplePuzzleMiniTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final MiniPuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return TextButton(
      style: TextButton.styleFrom(
        primary: PuzzleColors.white,
        textStyle: PuzzleTextStyle.headline2.copyWith(
          fontSize: tileFontSize,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ).copyWith(
        foregroundColor: MaterialStateProperty.all(PuzzleColors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (tile.value == state.lastTappedTile?.value) {
              return theme.pressedColor;
            } else if (states.contains(MaterialState.hovered)) {
              return theme.hoverColor;
            } else {
              return theme.defaultColor;
            }
          },
        ),
      ),
      onPressed: state.puzzleStatus == PuzzleStatus.incomplete
          ? () => context.read<MiniPuzzleBloc>().add(MiniTileTapped(tile))
          : null,
      child: Text(tile.value.toString()),
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
