import 'dart:ui';

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
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Column(
          children: [
            child!,
            SimpleStartSectionBottom(
              state: state,
            ),
          ],
        ),
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(
    PuzzleState state,
    SettingsState settings,
  ) {
    return Column(
      children: [
        ResponsiveLayoutBuilder(
          small: (_, child) => Column(
            children: [
              SimpleStartSectionBottom(
                state: state,
              ),
              SettingsSection(
                settings: settings,
                width: _BoardSize.small + _BoardSize.bgMarginSize,
              ),
            ],
          ),
          medium: (_, child) => Column(
            children: [
              SimpleStartSectionBottom(
                state: state,
              ),
              SettingsSection(
                settings: settings,
                width: _BoardSize.medium + _BoardSize.bgMarginSize,
              ),
            ],
          ),
          large: (_, __) => SettingsSection(
            settings: settings,
            width: 300,
          ),
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
        small: (_, child) => SizedBox(
          width: 184,
          height: 208,
          child: child,
        ),
        medium: (_, child) => SizedBox(
          width: 280,
          height: 284,
          child: child,
        ),
        large: (_, child) => Padding(
          padding: const EdgeInsets.only(
            right: 75,
          ),
          child: SizedBox(
            height: 480,
            child: child,
          ),
        ),
        child: (_) => Stack(
          children: [
            Image.asset(
              'images/duck_full.png',
              key: const Key('simple_puzzle_duck'),
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Image.asset('images/duck_full.png'),
              ),
            ),
          ],
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
      if (tiles.isNotEmpty) {
        return SimplePuzzleMegaBoard(
          size: size,
          tiles: tiles,
        );
      } else {
        return const LoadingBoard();
      }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 8,
          medium: 16,
          large: 16,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => Center(
            child: SizedBox(
              width: 300,
              child: child,
            ),
          ),
          medium: (_, child) => Center(
            child: SizedBox(
              width: 480,
              child: child,
            ),
          ),
          large: (_, child) => child!,
          child: (_) => Image.asset(
            'images/super_logo.png',
            key: const Key('super_puzzle_logo'),
          ),
        ),
      ],
    );
  }
}

/// {@template simple_start_section_bottom}
/// Displays the bottom part of the start section of the puzzle
/// based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSectionBottom extends StatelessWidget {
  /// {@macro simple_start_section_bottom}
  const SimpleStartSectionBottom({
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
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return Column(
      children: [
        Text(
          'A winner is you!\n'
          'Congraturation This story is happy end. Thank you.',
          style: PuzzleTextStyle.headline4.copyWith(
            color: theme.defaultColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16,),
        NumberOfMovesAndTilesLeft(
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: state.numberOfTilesLeft,
        ),
        const ResponsiveGap(large: 32),
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
    // TODO(JR): change/refurbish to our needs
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
    const outsidePadding = 8.0;
    final slidingAnchorSize = (boardSize * zoomLevel) / size;
    final megaTileSize = _miniBoardSize(boardSize: boardSize, size: size);
    final megaTileSizeWithZoom = megaTileSize * zoomLevel;
    final viewport = boardSize + (_BoardSize.bgMarginSize * 2);
    final marginAroundTile = viewport - megaTileSizeWithZoom;
    const paddingCompensation = outsidePadding * zoomLevel;
    final boardCompensation =
        (_BoardSize.bgMarginSize * zoomLevel) - (marginAroundTile / 2);
    final compensation = boardCompensation + paddingCompensation;

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (currentPosition.x != 0) {
        transformationController.value = Matrix4.identity()
          ..translate(
            ((currentPosition.x - 1) * -1 * slidingAnchorSize) - compensation,
            ((currentPosition.y - 1) * -1 * slidingAnchorSize) - compensation,
          )
          ..scale(zoomLevel);
      }
    });

    return Column(
      children: [
        const ResponsiveGap(
          medium: 8,
          large: 16,
        ),
        InteractiveViewer(
          transformationController: transformationController,
          panEnabled: false,
          scaleEnabled: false,
          child: Padding(
            padding: const EdgeInsets.all(outsidePadding),
            child: SizedBox.square(
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
          ),
        ),
        const ResponsiveGap(
          large: 96,
        ),
      ],
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
    );
  }
}

/// {@template loading_board}
/// Display the loading layout before puzzle starts.
/// {@endtemplate}
@visibleForTesting
class LoadingBoard extends StatelessWidget {
  /// {@macro loading_board}
  const LoadingBoard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ResponsiveLayoutBuilder(
        small: (_, child) => SizedBox.square(
          key: const Key('loading_board_small'),
          dimension: _BoardSize.small + (_BoardSize.bgMarginSize * 2),
          child: child,
        ),
        medium: (_, child) => SizedBox.square(
          key: const Key('loading_board_medium'),
          dimension: _BoardSize.medium + (_BoardSize.bgMarginSize * 2),
          child: child,
        ),
        large: (_, child) => SizedBox.square(
          key: const Key('loading_board_large'),
          dimension: _BoardSize.large + (_BoardSize.bgMarginSize * 2),
          child: child,
        ),
        child: (_) => Center(
          child: Text(
            'Hey! (Bum bum bum) Got any grapes? \n'
            'Then he waddled away. \n'
            '(Waddle waddle) \n'
            "'Til the very next day. \n"
            '(Bum bum bum bum ba-bada-dum) \n\n'
            'Waddling........ Please *quack*',
            style: PuzzleTextStyle.headline4.copyWith(
              color: PuzzleColors.grey1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
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
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size,
      children: tiles,
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
        if (settings.isSuperPuzzle && !tile.isCompleted)
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
        if (!settings.isSuperPuzzle ||
            (settings.isSuperPuzzle && tile.isCompleted))
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
              if (settings.showNumbers)
                Center(
                  child: _HintNumberText(
                    text: tile.value.toString(),
                    size: 20,
                  ),
                ),
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
    final settings = context.select((SettingsBloc bloc) => bloc.state);

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
          if (settings.showNumbers)
            Center(
              child: _HintNumberText(
                text: tile.value.toString(),
                size: 10,
              ),
            ),
        ],
      ),
    );
  }
}

class _HintNumberText extends StatelessWidget {
  const _HintNumberText({
    Key? key,
    required this.text,
    required this.size,
  }) : super(key: key);

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
        shadows: const <Shadow>[
          Shadow(
            blurRadius: 14,
          ),
          Shadow(
            blurRadius: 8,
          ),
          Shadow(
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}

/// {@template settings_section}
/// Displays the settings for the Puzzle.
/// {@endtemplate}
@visibleForTesting
class SettingsSection extends StatefulWidget {
  /// {@macro settings_section}
  const SettingsSection({
    Key? key,
    required this.settings,
    required this.width,
  }) : super(key: key);

  /// Current settings state
  final SettingsState settings;

  /// Width for the settings pane
  final double width;

  @override
  SettingsSectionState createState() => SettingsSectionState();
}

/// {@template settings_section_state}
/// State for the settings section.
/// {@endtemplate}
class SettingsSectionState extends State<SettingsSection> {
  var _settingsState = const SettingsState();
  final _textFieldController = TextEditingController();

  @override
  void initState() {
    _settingsState = widget.settings;
    _textFieldController.text = _settingsState.userImageUrl;
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final superSizeLabel =
        '${context.l10n.puzzleSuperBeLike}${_settingsState.megaPuzzleSize}';
    final minisSizeLabel =
        '${context.l10n.puzzleMiniBeLike}${_settingsState.miniPuzzleSize}';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            border: Border.all(
              color: Colors.black12.withOpacity(0.1),
              width: 6,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  context.l10n.puzzleCustomize,
                  style: PuzzleTextStyle.headline4.copyWith(
                    color: PuzzleColors.grey1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Text(
                      context.l10n.puzzleMakeSuper,
                      style: PuzzleTextStyle.headline5.copyWith(
                        color: PuzzleColors.grey1,
                      ),
                    ),
                    Switch(
                      value: _settingsState.isSuperPuzzle,
                      onChanged: (value) {
                        setState(() {
                          _settingsState =
                              _settingsState.copyWith(isSuperPuzzle: value);
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      context.l10n.puzzleNeedHelp,
                      style: PuzzleTextStyle.headline5.copyWith(
                        color: PuzzleColors.grey1,
                      ),
                    ),
                    Switch(
                      value: _settingsState.showNumbers,
                      onChanged: (value) {
                        setState(() {
                          _settingsState =
                              _settingsState.copyWith(showNumbers: value);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  superSizeLabel,
                  style: PuzzleTextStyle.headline5.copyWith(
                    color: PuzzleColors.grey1,
                  ),
                ),
                Slider(
                  value: _settingsState.megaPuzzleSize.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _settingsState = _settingsState.copyWith(
                        megaPuzzleSize: value.toInt(),
                      );
                    });
                  },
                  min: 3,
                  max: 5,
                  divisions: 2,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  minisSizeLabel,
                  style: PuzzleTextStyle.headline5.copyWith(
                    color: PuzzleColors.grey1,
                  ),
                ),
                Slider(
                  value: _settingsState.miniPuzzleSize.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _settingsState = _settingsState.copyWith(
                        miniPuzzleSize: value.toInt(),
                      );
                    });
                  },
                  min: 3,
                  max: 5,
                  divisions: 2,
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  context.l10n.puzzleTryUrl,
                  style: PuzzleTextStyle.headline5.copyWith(
                    color: PuzzleColors.grey1,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: context.l10n.puzzleFeedImage,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _textFieldController.text = '',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                PuzzleButton(
                  textColor: PuzzleColors.primary0,
                  backgroundColor: PuzzleColors.primary6,
                  onPressed: () {
                    final currentSettings = _settingsState.copyWith(
                      userImageUrl: _textFieldController.text,
                    );
                    final isUpdate = currentSettings != widget.settings;

                    // Tests if an update was made by user,
                    // or if it should just reshuffle
                    if (isUpdate) {
                      context
                          .read<SettingsBloc>()
                          .add(SettingsUpdated(settingsState: currentSettings));
                    } else {
                      context.read<PuzzleBloc>().add(const PuzzleReset());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/shuffle_icon.png',
                        width: 17,
                        height: 17,
                      ),
                      const Gap(10),
                      Text(context.l10n.puzzleLetsGo),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
