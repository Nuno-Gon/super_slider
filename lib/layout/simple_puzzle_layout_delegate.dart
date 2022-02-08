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

    if (isMegaPuzzle) {
      return SimplePuzzleMegaBoard(
        size: size,
        tiles: tiles,
      );
    } else {
      return SimplePuzzleMiniBoard(
        size: size,
        tiles: tiles,
        settings: settings,
      );
    }
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
    // TODO(JR): temp - here for testing
    final puzzleSize = state.puzzle.getDimension();
    final total = puzzleSize * puzzleSize;
    final completed = state.completedPuzzles;

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
        Text(
          'Progress visualizer: $completed/$total',
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
  static double bgMarginSize = 60;
}

double _miniBoardSize({
  required double boardSize,
  required int size,
}) {
  return (boardSize / size) - 4;
}

/// {@template simple_puzzle_mega_board}
/// Display the board of the mega puzzle in a [size]x[size] layout
/// filled with [tiles] and the board background.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleMegaBoard extends StatelessWidget {
  /// {@macro simple_puzzle_mega_board}
  const SimplePuzzleMegaBoard({
    Key? key,
    required this.size,
    required this.tiles,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final extraMargin = _BoardSize.bgMarginSize * 2;
    final transformationController = TransformationController();

    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final currentPosition = state.activeTile != null
        ? state.activeTile!.currentPosition
        : const Position(x: 0, y: 0);

    late double boardSize;
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= PuzzleBreakpoints.small) {
      boardSize = _BoardSize.small;
    } else if (screenWidth <= PuzzleBreakpoints.medium) {
      boardSize = _BoardSize.medium;
    } else {
      boardSize = _BoardSize.large;
    }

    const zoomLevel = 2.5;
    final slidingAnchorSize = (boardSize * zoomLevel) / size;
    final megaTileSize = _miniBoardSize(boardSize: boardSize, size: size);
    final megaTileSizeWithZoom = megaTileSize * zoomLevel;
    final viewport = boardSize + (_BoardSize.bgMarginSize * 2);
    final marginAroundTile = viewport - megaTileSizeWithZoom;
    final compensation =
        (_BoardSize.bgMarginSize * zoomLevel) - (marginAroundTile / 2);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (currentPosition.x != 0) {
        // TODO(JR): y isn't working as it should. ResponsiveGap responsible!
        transformationController.value = Matrix4.identity()
          ..translate(
            ((currentPosition.x - 1) * -1 * slidingAnchorSize) - compensation,
            ((currentPosition.y - 1) * -1 * slidingAnchorSize) - compensation,
          )
          ..scale(zoomLevel);
      }
    });

    return InteractiveViewer(
      transformationController: transformationController,
      panEnabled: false,
      scaleEnabled: false,
      child: GestureDetector(
        onDoubleTap: () {
          context.read<PuzzleBloc>().add(
                const ActiveTileReset(),
              );
        },
        child: Column(
          children: [
            const ResponsiveGap(
              small: 32,
              medium: 48,
              large: 20,
            ),
            SizedBox.square(
              dimension: boardSize + extraMargin,
              child: Stack(
                children: [
                  const _BackgroundBoard(),
                  Center(
                    child: SizedBox.square(
                      dimension: boardSize,
                      child: SimplePuzzleBoard(
                        key: const Key('simple_puzzle_mega_board'),
                        size: size,
                        tiles: tiles,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const ResponsiveGap(
              large: 96,
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundBoard extends StatelessWidget {
  /// {@macro simple_puzzle_mega_board}
  const _BackgroundBoard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.brown);
  }
}

/// {@template simple_puzzle_mini_board}
/// Display the board of the mini puzzle in a [size]x[size] layout
/// filled with [tiles] inside the mega tile.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleMiniBoard extends StatelessWidget {
  /// {@macro simple_puzzle_mini_board}
  const SimplePuzzleMiniBoard({
    Key? key,
    required this.size,
    required this.tiles,
    required this.settings,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// Settings state.
  final SettingsState settings;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SizedBox.square(
        dimension: _miniBoardSize(
          boardSize: _BoardSize.small,
          size: settings.megaPuzzleSize,
        ),
        child: SimplePuzzleBoard(
          key: const Key('simple_puzzle_mini_board_small'),
          size: size,
          tiles: tiles,
        ),
      ),
      medium: (_, __) => SizedBox.square(
        dimension: _miniBoardSize(
          boardSize: _BoardSize.medium,
          size: settings.megaPuzzleSize,
        ),
        child: SimplePuzzleBoard(
          key: const Key('simple_puzzle_mini_board_medium'),
          size: size,
          tiles: tiles,
        ),
      ),
      large: (_, __) => SizedBox.square(
        dimension: _miniBoardSize(
          boardSize: _BoardSize.large,
          size: settings.megaPuzzleSize,
        ),
        child: SimplePuzzleBoard(
          key: const Key('simple_puzzle_mini_board_large'),
          size: size,
          tiles: tiles,
        ),
      ),
    );
  }
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => context.read<PuzzleBloc>().add(
            const ActiveTileReset(),
          ),
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: size,
        children: tiles,
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

    const tileColor = Color(0xfff0f0f0);

    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 10,
          left: 10,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
              color: tileColor,
            ),
            height: 4,
          ),
        ),
        Positioned(
          left: 0,
          top: 10,
          bottom: 10,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                bottomLeft: Radius.circular(3),
              ),
              color: tileColor,
            ),
            width: 4,
          ),
        ),
        Positioned(
          top: 2,
          left: 2,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: tileColor,
              border: Border.all(
                color: Colors.black12.withOpacity(0.1),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(3),
              ),
            ),
          ),
        ),
        if (!tile.isCompleted)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.5, 2.5, 1, 1),
            child: BlocProvider(
              key: ValueKey(tile),
              // TODO(JR): when added, flickers; without, puzzle breaks
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
          ),
        if (tile.isCompleted)
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 3, 1, 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: tile.displayImage,
                    ),
                  ),
                ),
              ),
              // TODO(JR): show piece number?
              // Center(
              //   child: Text(tile.value.toString()),
              // ),
            ],
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
                        5,
                        //'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Anas_platyrhynchos_male_female_quadrat.jpg/1200px-Anas_platyrhynchos_male_female_quadrat.jpg',
                        'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAoHCBYWFRgVFhYZGBgaGhoaHBwcHB4cHhwcGhoaGhoaGhocIy4lHB4rIRgYJjgmKy8xNTU1GiQ7QDs0Py40NTEBDAwMEA8QHRISHjQrISsxNjExNDQ0NDQ0NDE0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0ND80NDQ0NP/AABEIAKgBKwMBIgACEQEDEQH/xAAbAAABBQEBAAAAAAAAAAAAAAADAAECBAUGB//EAEAQAAIBAQUEBgkEAQMCBwAAAAECABEDBBIhMUFRcZEFYYGhscEGEyIyQlLR4fAUYoKSciOi8TNTBxVDc7LC0v/EABoBAAIDAQEAAAAAAAAAAAAAAAABAgQFAwb/xAAqEQACAgEDAwMEAgMAAAAAAAAAAQIRAwQhMRJBUQUycRMUImGBkSNCsf/aAAwDAQACEQMRAD8Az79dnsCbPEts65+wrEAUGlcqjWoHGdj6MdOLeEVWJNqFq1RrQ0qCMiaUrH6PsDYW2JbKjsGHrCQyUBBKsgaocVpkczTXOcz0p0ciWxa7KSqk0VAcSEAVDDafez6oseWtyE4WehxTn/RJLbATaVCHNA3vV2kblOXbWat96Qs7JQ7tQE0FM6nqpLcZXGyu1TotxTLuPTCPYm2YhFDFWrsNctN4Kntly53tLRA6GqkkVoRmNcjJJp8C3LIMeshHgFkqxVkY8AsVY9Y0UBD1j1jRRgPOP/8AES5s6WdoK4ULI4G5wKHsK/7hOwEDe7olqjWbiqOKH6jcRr2SE49UaJ45dM0zz3oro2yWzZ8IYUq2IBuNKidN0MgWws1Yezgpls/BlODs721klrYMaMrMh7CVbPsPOaXo0yAUd3tQCSFCuyrTTCQMJ685kTjLe2ehxyjJKl2O1QIFOBQDw85TsRjelK1BHhmO0CV7S9VNQpWu0jDXsl7oihtBvCE96/eQxR6pqLHnl9PG2jcRaADdlHjmNNxKlR5tu3bEIqxRGMQjIyUVICIxSREaFgNSNSSijsCMVJKKFgRijxQsBoo8ULChqRR4oWBwXRXTzI+Jyzg5ULkCpGTDYDkOys0Lncle2/Ve4ykM1nqCSCAyumu1s66zmV6NJQFMRIOxCVB0oXGnVxl+53G3xuoRh7qnHrjoGwqwOTUbEBtA3zKpJbF+Lfc6u+3M2pxesOHCQyMcKvWrCuEqTlTU6SHR90SyV1a75AjGhYOA2gdAaEBlam3ZxgLn0XgLkuGxWeEYwcSvvYHMZ0pWtKyx6shiWyYUFoRlTCpqQwpVDUa7mIzEOp+SXSvBn3HoG6WtnX1lrZ099MdaVp8JQ1AO3q1mQt+NhisrN7RQloWOavUZLU4QBT2Ttpn1TqP0LI2NCVapxsBUFGIo1MqHgNpggiDMoCTtpXEp3EaVYVHCSjNoTxpm2jVoc888wQe0HMSUxlvzpaInsizoAGYNWtaFS1aBhUAA7s6bbHSfSi2aBgyMS1KVrlX2vdrT7y9DJFxspzi1KjRjwNheUcAo6tUVyIOXCErJ8kaJxSMeMQ8UaPACQijAxwYAeb+n3RPqbYXpSMFo2F13PhNexgteIO+A6AskNC1s+H5QwAz7K0nTf+ITobqUZhjxIyLtyNCeoULZzzO4WDs4RCatkANsz9RFXszW0mSSjuj0G/XqzX3TUDQDUndND0fVg4Z8i9ctwoSBMjovoVLP32xvt+UdQ38ZsetwkEag5SjGahNNGjOEskGn3R0lIqSrdr4GpXI9xlmbUMkZq0zzuTFLG6aFFHrGnQ5CpFFWKACrGj0ipABoo9IhABoo8VIANFHpFACMUlGMAGijxUgBzosAiKiWoorAkeyAWO0BTpnWhrmDummltjbBjs86OxFK1UYR7VaYvZGdMqdcyFuSa4F5CFF1T5RylH7WXkufcR8G6ejcy3x5kEn3iaYlPzCiryG6CvnQzvaC1R1bII9m2aOtTmTXIgM2zbxrlfpU+VeQk1u6bFA4ZeEPtX5E868Gu/RzAOVFXw+yrMMAIAAzGY0AzB064FujmyLGm84icPsmoB2gGmu4E5iZi3dRmBThUHuie7JiJVSoOwM3fnn2wenldWP66o136ODKQVqtDUCmeLMsP3VzrrWZi+jF3IKlnDZaMpyzOdVp/wASBsF/cKgA0ZhWlBnQ56SK3RQcQxAjbiavOvWZJYJLuReaL7BujehfV2hIIw5qgBOI1JJx1AFaACo65pVmSLCh95/7N9YZXYADEfHxnfHGUVTOU2pO0aNY9ZQ9c3zdwklt3r7wPEDynU50XgYqyj+obevKZ6dLFzhQim8ZV+k45cscauR2wYJZXSNx7VV94gTC6V9IsFVs0OL5mFBxC7ZYW7k569cz+l7vVQBrKE9e26S2NSHp0Vy7Zw3S9raOxZyWJ1JzlC64sYKEqwNQd07yxuqaPZqeukO/QVi1CiBWXPLKo2g75xedMsxwdJS6OvjFQGNTv0mhZWbOchlK3/lS2bqQxKEVprSs3MagALSkqt3wWVaRKxZVGE58JOzvTKNctzeRklUFdKcJTvSGTjOcH+LISxwntJGlYX9WyOR7uctiY13s1I3QqW5RqZldo8xL+HW7pT/szNR6et3j/o1YpW/WL18o/wCtTr5GaSMlprYsRSv+tTf3GIX1N/cYxFmIyv8ArE+buMX6xPm8Ytx0WI1YD9YnzCL9UnzDnDcQesVYD9SnzLzEf9UnzrzENwC1jwIvCfMvMRxbL8w5iABYoPGN45xYxvHOFgYdmJMNnBA/n/EkD1wJBwY5ag+kCF669phB2c/rGBIN1GNi3CIGMw/BEBIYvz8EkWNNIIJ/l/aTBpv5xkRw2+PiG8cJCoO0iNh3mBIIzcJIQedNTyjJaDrG/L7QAo9PXrAgUHNzh/iBVvIdsybgCMxIellv/qWQFaYHPNlHlK92vQG2Y2tk5TrwbugjGOO/J190vOVDB2lGNZj3e/gzQsnlIvqPdBLZQBFdCdAY1oKyd0QgwG+AhoGprLDICNJQtLWlpQzQDikkqIu9gNm9DSEtKGCVPahLXKIO5BBsjtQzOtr2AdYwvUi2S6S/dnOa108IUnr8JnXW2OPL5TtptHVLwtN9Ow18pu6STliTZ57XQUczr5J0kWB/BFiGyvZGII0PMCWilY5B3DlGwndIm1Xaadsc2gOjciPCAWRZwNQPCRDg7pOp3/nKKm2o5VjER7BG7IQ/mUg35lACMbLdHDHWo7/rFGIgQu6LCN0JkJD1vH+pgAIE78vzfJkDtldGB298OpG+QJkgOMbLUk9unhJIDrHYwFQj+aRqjj10+0ZlOynh5xKzbu/7RiJBs9e77SdRvgWZ66ciPMSQD7yOXkYEh1ND71a75MPu7jWCZWGdSeArEGqMxXiKeUBIKQdan87I/tdX52QQO+o/OsSF7tlRGepOFSddo0HOkTdKyUY20kcn6WXnFeLNNqBgTsJYqSOyneZXbo60IqhHE6DjCPYYwGObYq18ZpF8CZ7ph5srlO0ehw4ujHVnKXHpJktGR6Ag05ZTsrhfKgTzK8vjtXcaYjTnNvonpcqaNz3DIVPOGXFtaHhy0+mR6Qj1l67ETmbn0ipGs17K39nIyqnXJakrWxW6TtKWvZLt1tqicz0teWW2GI+8opzM0rhexvjYLijpkUUqZmdI3rdAX3phAubU2dsxhbeueimqfEerdXeYN7EYxrdmFf8ApFnvGBWwgbd5OeU6q5WZwAk1O+ct6Z3UI9nbKKAjA1P26dxHKdL6PXjHZiTmk4qSIwb6mmWbsPbrspQ9s0XUDPMca/eRaxCrGRsqg59vlL3p+XmDM71PEqWRfDDKDvyicNnRjyHnBJi39kJnTOg7/ETVMcHibrPL6xAMdcXd9ZBm3OeGEeQjpb7MXcPMwIhAh3mkY8Ty+kZC2wnuIPKM77/KkYCBrqa8R95J8tv52CQIB+FeUWMjKi9h8jAB/WLvj0kWYfLn2fWMd+ztjESYLvkKjeI2GvVJerHX+dsYyuLZd4HHLwk/WjKrQCqu4jrofCLE2wZbz7I7xOboaLS2o2PzpCC06weErWRJPVpXKWDlpn2gQ2GObX8pG9YN475Au37ecQY7AOyMAgtxJ4wYIYvwGvjJesO4wIkwme784Sbr+fglS0wHWtesfWMlqRt5g+IygBZU1+Ly8pm+kQpYFQT7TIuvXiPcsui0YjTkQfKZ/SIxsqAZLmeJyA7zznDUTUcbZa0kHLIkipcLvWkbpG5m0ZbEGmI+0dygVY8oW63jCWU6iWbiWxNaYS1fZByGQOeR3kd0yNNjc8q8G1q8308T88HEeltw9VeH2LaBXXqyCsBwIr2iZqXDHtHVO89KLqLxZUwMHsziQ/8AyU9RHeBOVuFGA2GW9SnB2ippJLIqfKH6GujaYzwnbdF9GIR7TvXdWg8JzN2uBZqo9GBrQ6GdHcbpaGpLhabhlM6crZqRVRoF090SrnJjkQBnmNcx2SI9G2VQys57R9IIh7VyC4Ug5U28Zs3NrdVKMh/yqKcZG3Q2jGT0cDH/AFGJHy4vGk0VsURaKuQ2CaaWIAqdZRveQ4yDk3sdI0jmvSWzNrZogFC1ooG2lQRXzlrotRY272S1wAgpiqDhIqNdxrymncLlV/WGns1wDbUihY9hI7TM/wBJlKPZ24/9t9Osqdetu6aS07+3vvyZb1K+56e3H8nSuarA3e1Cgg11gOjL6HFPz8yhnTM50HWSJw0j6cyO+tj1YH/YYWwO/LqMEbzU5eY8RIYdxH9j9YzNTXL+X/M3jzQU2lfhJ4UkfWD5WHCvlANaA/G/YPtEr/uLdgr5RgHxp83MkRwBx7fvAi0UbH7QTHDodKV7KwALTZkeMEwfYE5GJ2XaSOAPlWAFsoyFR2MPFYATwvXMr2KPqI7FuHD7GSLE/CG4mnlIMoPwkcCKePlGARGI1xHjJ4h185XN2G8wf6dd45RhsCFip2EbiFH4JL1RHu2h7dOREfZqfziTzjLajQpXln3yBIKEY5FgeH0AhUQjQ1/OuVcZ+Q8u7KSxv8gA6/8AiLcC2RXUeMgxTceZ8JXFsRlhB/kvhlIteiPgPaPvGRLSqo0CcyIntVXXCOGI+EpLfmPwU4f8Qq25/d2AfaFAXkoRX2Tz8zJYRuHP7TOtLQHIu6niR5SBup1xlusqT3qYDo0bQKqk102bydNeuks3G5qEJOp1O+YTXf2kFakknbotN/WROpu4ogEx9fkbmo+Da0GPpx9Xdsw770Ux9vFQkbNabJbslCgLQZADXd2SzfrWigDUzOCLtB4V+s7enx2cjj6jO2olm1UnatNxB+s86To51c4RiwsymnUxFe6d2toFOQb/AHEfSYXQVoa4vmJJ7TXzktfKooPTo3JmHdrZ7O1KlWrsyOh0nYXG3dkOJGHXKXpDaYLZLQe6VwniCT5901rheQbMkHrmTJp0zZiq2Mu7Xdy2JCozOtTt6puWVrbqCrJXcwORmT0ba1J4nKhG3cQDOgS1qABItkpFP1zrqtR4StenrnSbos6LnMm/MIor8kmRctm0QS+BQFwmoFPrrBX+3srWzezdl9oU1zBGakZaggGGFjrlyr9ZF/zZ5T0qiumjyzl+fV+zl+iry6GycioYYSBvFK9v0nbW6ClaVE4+7/8AUwaYHfx9k/1pOyP/AEhwmJL8ci/TPRL8sX6aK4tBT3WHZEbwN55HzlcWzbQtO2M14p8Q/qfEzeTtWeakqdE3dj7rfnY0kVJGbU/OMrtaE7T/AFPlInPSg/NzCMiGag1q3NvKQNijapzA85W/TuDVXHaB5CTxONX5BvpAAy2aDcvbTzkkRfmJ/kTK7Yzo/YV86COthvCHrAoYwLLWxXQeH1jC36l/OcB6umhP+6O1mTqAeMA2DG0B2U4GniI9ervH0lYWZHuqvdGq/V3/AFhYFRVqalxXqrJknTETxP2hLRyq6AcDU8qRsehyNK6VGu/fyiAHVt7fx+8IjuNCT/lSQFsa5qKcpD1g0Bp/GsALgtD8WEcCJF7RAc2HMSqrtorg8VH0kC7j41/qBALLhIb3X7vrE11Xa1e2ngZXF8yoXHYKjugXJJ95CN+YgBqIijaf7GI2hB90kcfqZmBRozpT/JgY6WSA/HT/ACDDvgOy6j1txuCDsJY7uydEz5ATneg7AG1dh7oy7aCaHSd5wjWef1Dc8zryekwJQwq+ysB0jaYmoMJA1xA0r1EaH6wK3dSM1HYa+MaycAUxBoRbRfm/O0zawY+iCRg58n1MjkRN1I0bxmF0LaYHNk+TKcJH51UPbNi92jIjv6ygVWY1Ap7IJ8pw116WV3V7Q4HPvGlFO401Ug5buucNbjco7FrQZOiTvg9CvyBkoyhhXjH6HskXTTdJ3ALaWdEdHP7WDeBk7rdWXZMNxktmbqnF8MdMOLMZ1M0rLDumYtg2KX7GyYZ0iVik1XIS824AMwrzbA9e3LcNTLHSl7sk9+3s0PWwJH8QSe6czf8A0psERkuyM7sCGtXFABtwqfOlK7ZYwYZymm1sV8ueEMbSe5u2V6UbT2/aENvtClv8fvSV0swyhgFowBGZ0IrtkHs6bzwP3noUedZm2JxXl6gipGutaCdg4As5xVoSl5BIIxqCOK1B8BOwdwbMEbphalNZWei0zUsSKYNd3P7RMtPiPbMoO1SQ4Ge8CFx2m+v9T4Tbh7Ueeyr838l09h4GLsf+33mezvtVT/ERevb/ALbfxpJkKLhtGHwt2sI4vB2q3j4TLe8KNbJzxziS+bFQr2geIgI0mtK/BzxDykWdBrTtJlZbw51TtxDyETYtgPAOPAiFjoOjoNMPM/SO9so3f7h5SqXc5YWHI+EEUcaDx+sAaLqWqNsz6iD95L1abpRGPaQOI+8l6w/Mv5/KFhQexZQM6CueZqe+sT3hBtHZKXrxtdv6QikH4geKn6QEEe+WR+L87Yv1CbBzAkDYnXCnL7Qi0A1VT1UPgYAMlqD8nKh8JJ8HxYeX3g3tRtdeBYCQX9oU8DWAE62WwAdf5WDeys21djyEn7W1ZAouuA16jABJZIPdBfqJFJOzoNEwdasZHE3yADrjPamh9ru35SMpdMWycI9Ukka/QKEWbuSfaYsOFTr1yrfnZzSgI66+I0m1Y2ISw6gBynJv0i+dGyrsH1mVo4deRzfY19Zl+njWNd/+Bmuw+RudfGIADIi0HZUc5BekztrxEe8dLYELE6bDSpOwDrmuYyMf0g6RUB7JCxoB6ytCFBpQU66jnOba7+yKLUEVAAxdoU5gcKQt5t3f1rtT/VzNNlDUDrGQHZJ9Fvis8PxYlWu5Rr3eE5SZZiqRQAwmoJy2hiD2YgfGaVw6bvC1VLzapkaVYkV1z9rLbsg78SrUNT7NV3AsuQA4mGv9kqPhFMkArl7xBY1rtoO8CQcYy5RNSa4YVPSG9kuDeXOGmfu1qaZZjqlO2vlraH27Z26nfyNTIXKxLhnFFChQdNWzGR1Bpr1dcsq9NuFWNS2WS02VyGmvGLoiuENzk+WV0sVrvO6jOe+gprqITDQmopQfF1iuQ02yFlbipwCvtHCd5JyXryyPUTJ29iS1WyU5gcSTU/mlJIidh6M9IY7MoWzswoFflNQteGEjlNd1rogY76icF0NejZWwf4MlPWprXjSteyd362uooOsgeE6xdoryVMzOmQcVg5BBFoV1rkwr/wDWdGzUsUB3d2yYl+sw4QLQ/wCoh8azevy0VRuEydWl9ZL4NjRS/wAD/VmYUTbTujhUGkjUbD4Rqk6HvrTsmsuDGd2FZAdneZA2P5U/WAo+1u6QZH1x8x9JIQc2a9ffIGxHWO36iCF4YaunORxlyAoRmOQGZJO4AQFQQ2JGjOOZHcJJUb5q8/OWE9H7Wox2t3sWOiO1W/qM479HIDRr5dB/Jh5yPUvJLpkVGswdjV6ifpF6ttnf+CSvFxQAFLxZWgJpRLWp5NoOJlJrv+91O4jMHrEaknwJprksMXGqqeP4YPGu1E/OyQCuvxYuweZixH5By+8YBXVtjEwD2r6FT2xerc5gV/xMTI+2o4xsiQa3ByYkcCZBkGxyZP1P7awtlZH4R3xAVlSvwhuOUmbFhsUDjLDqx20ghdTvMABqx2AePjJh6a69Qp5yQRtigyQR/wBq8YADqx0J51h7qhZ1VtCfDPykfVb2HZLfRtiGtEAOWLUnqJ8jynDUOsTLWlV5Uddd7MMmBtCKcxOTvNywOyEiqmmmu48p01+vS2b2a1GZoRtoRkedOc5/0kxC2YrmWVSOVPKUdDJxk0+5c10VKKkiv6ldq17pwnpZf29bhQYVSoHWcsRP5pTfOsFs/wAZI/Oqcp6V3NVcWgb2nOYOWgALA7vdFCNTNOXBnQqzFsb+V1GW7dWXrJVqcLih+TXmTKt1uAOtOqorXhShitejCNAp4FgeREgzuWL9as7YmcCgAqaVyy2Q126VQtR+s4htqKGvVoeyZCWb2ZxUYHfQEd8ladIs2oUneVA7xFsBtWZRVwoxdmIx5mgI0UmgAAPGCZ3xYiykDUIMQrocTt7I5nhKt86QUsyoMSA+yWqTSg2HIHsli73ixYe2pdhstLQIv8VUU574uAAJfQjhlwsw91FzUa7e/KGQXi1YVqo34dnVUVJl576+lmthZLsCksR3Z9snYWKspxuz6Vyy1+VcvGJyCirbW6L7K5lddtdK+1tNa8p0fQt79ZZgAVw+yTtps+nZOR6RdS/s1UZAECgy8J0vofYsqO7P75AABAyStSRvqTy65OL7kJq0dH0TcyXBwjKprU1zyp3906LpMkAmnwnvBgeiLMrQMfab2jvp+GWelhUEdRA47Jj5cinmvtZr4oPHh6e9NnJpYjbi7IjdUGeNuYg7V32L4ytiOjITNwwWaCKPhZ/ztjMj/OD/AJLMt1FfddYhagahzxMYUavs0zAPD6QFleyjkWQwN6vNiM1xNQYdxyOe4GVFvaj4CBxisWRntGHu4bMGvFj5yE+CUFuXrFEUkhqsdWJqzHeTthFQk5HEfzqgLqtljUMKg1yU5mgrQHZ1nYKmaVl6Tuvs2KpZJsAUFm3Grg0HEE76aRNpOkhpN7tlW0uzlWUKanfoDsJFM4K52jtZozowOEVxLyrXPq7JoP6U3vYzHr/0/wD8Qd39LL2yo2MEMAaFENKitPdBOsi5NNbD6U4vcqMEP5Xxg/Vrv/OcNb38WjkMoVz7QIFFYHKoGzPIippUUNMpW/Up8o/qZ0UrObi0GV22kf1BhLNiNXY8aeQiikkIKxDChGLq2U84yuRkq06o0UBDs5OqiAx1NKU41pzpSKKACcnbp1QRddor2xRQJAnNdDThElrgKsDmrBh102doqO2KKcsyTxuzrp5NZVXk6P0kc1s7VAWUqM8JIByI00r5TP8ASDpFXWyCI6uFJfEKe9hw03jI5x4pT027VmhqklB15MU+sIqchsP3mB6T3WiK5zoSvPOunV3xRS/LgzYe5GLcAtCCD2sV8JbXBsYng7nwEUU5ncIrt8If/f5yregfiy4hSeRNYoodgA3e9IAK1B3gVHjWXbK9p/3F7cQ7iwiikewFxbdaaI3An7wtlbKA1UYV/dUeEUUiMy7zQGvbmQO/ZOo9HLJGslpQYmIOlAzEDIjqoaxRSUvY/gIJOa+TtLUlLzZ0NQq4DpqwDV3/AAiX75ek9onZs3ndGimTKCU4/wAGtFt45Sf7OSS8OtarWum2nChGcgt8Nc6/1iim6eelyFNoja/nfBGzTWpiijAa0uiMMjXtlayu9BaINrKP9mKKKc59vknDv8ErhYYbW0rnhsKDi9oAe5SO2EwcaxRQj7mKXCHYuAc8qHYI129mzQZZKPACKKD9yHH2sgSTaWeQ/wDU5YCfECFa2Oxk5CKKH+zG+Ef/2Q==',
                      ),
                    );
              },
              child: Container(
                color: Colors.transparent,
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
      child: Stack(
        children: [
          Positioned(
            top: 1,
            left: 1,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: tile.displayImage,
                ),
              ),
            ),
          ),
          // TODO(JR): show piece number?
          // Center(
          //   child: Text(tile.value.toString()),
          // ),
        ],
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
