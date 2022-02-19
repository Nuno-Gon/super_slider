import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/settings/settings.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/utils/utils.dart';

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
          small: (_, __) => Column(
            children: [
              const SimplePuzzleShuffleButton(),
              const SizedBox(height: 32),
              const SimplePuzzleImportButton(),
              const SizedBox(height: 32),
              const SimplePuzzleExportButton(),
            ],
          ),
          medium: (_, __) {
            return Column(
              children: [
                const SimplePuzzleShuffleButton(),
                const SizedBox(height: 32),
                const SimplePuzzleImportButton(),
                const SizedBox(height: 32),
                const SimplePuzzleExportButton(),
              ],
            );
          },
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
    // print('DOGSON: PUZZLE TYPE: $puzzleType');
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
    // print(tile.toJson());
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
          large: (_, __) => Column(
            children: [
              const SimplePuzzleShuffleButton(),
              const SizedBox(height: 32),
              const SimplePuzzleImportButton(),
              const SizedBox(height: 32),
              const SimplePuzzleExportButton(),
            ],
          ),
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
      title: status == PuzzleStatus.complete ? context.l10n.puzzleCompleted : context.l10n.puzzleChallengeTitle,
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
    final currentPosition = state.activeTile != null ? state.activeTile!.currentPosition : const Position(x: 0, y: 0);

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
    final compensation = (_BoardSize.bgMarginSize * zoomLevel) - (marginAroundTile / 2);

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
            ResponsiveLayoutBuilder(
              // TODO(JR): Simplify
              small: (_, __) => SizedBox.square(
                dimension: boardSize + extraMargin,
                child: Stack(
                  children: [
                    const _BackgroundBoard(),
                    Center(
                      child: SizedBox.square(
                        dimension: boardSize,
                        child: SimplePuzzleBoard(
                          key: const Key('simple_puzzle_mega_board_small'),
                          size: size,
                          tiles: tiles,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              medium: (_, __) => SizedBox.square(
                dimension: boardSize + extraMargin,
                child: Stack(
                  children: [
                    const _BackgroundBoard(),
                    Center(
                      child: SizedBox.square(
                        dimension: boardSize,
                        child: SimplePuzzleBoard(
                          key: const Key('simple_puzzle_mega_board_medium'),
                          size: size,
                          tiles: tiles,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              large: (_, __) => SizedBox.square(
                dimension: boardSize + extraMargin,
                child: Stack(
                  children: [
                    const _BackgroundBoard(),
                    Center(
                      child: SizedBox.square(
                        dimension: boardSize,
                        child: SimplePuzzleBoard(
                          key: const Key('simple_puzzle_mega_board_large'),
                          size: size,
                          tiles: tiles,
                        ),
                      ),
                    ),
                  ],
                ),
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
          size: size,
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
          size: size,
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
          size: size,
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
                      child: Image.memory(
                        tile.displayImageBytes ?? Uint8List.fromList([]),
                      ),
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
              onTap: state.puzzleStatus == PuzzleStatus.incomplete && allTilesDeactivated
                  ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
                  : null,
              onDoubleTap: () => context.read<PuzzleBloc>().add(TileDoubleTapped(tile)),
              onLongPress: () {
                // TODO(JR): Here just for the purpose of testability; remove
                context.read<SettingsBloc>().add(
                      const SettingsUpdated(
                        4,
                        4,
                        '',
                        //'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Anas_platyrhynchos_male_female_quadrat.jpg/1200px-Anas_platyrhynchos_male_female_quadrat.jpg',
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
                  child: Image.memory(
                    tile.displayImageBytes ?? Uint8List.fromList([]),
                  ),
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

/// {@template puzzle_import_button}
/// Displays the button to import the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleImportButton extends StatelessWidget {
  /// {@macro puzzle_import_button}
  const SimplePuzzleImportButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () {
        final bloc = BlocProvider.of<PuzzleBloc>(context);
        final controller = TextEditingController();
        final _formKey = GlobalKey<FormState>();

        showDialog<Object>(
          context: context,
          builder: (context) {
            return Form(
              key: _formKey,
              child: AlertDialog(
                title: const Center(
                  child: Text('Enter Code'),
                ),
                content: TextFormField(
                  maxLength: codeLength,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[a-zA-Z0-9]'),
                    ),
                  ],
                  controller: controller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please insert a code';
                    }
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        bloc.add(PuzzleImport('QUACK-${controller.text}'));
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Find Puzzle'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        );
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
          const Text('Import'),
        ],
      ),
    );
  }
}

/// {@template puzzle_export_button}
/// Displays the button to export the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleExportButton extends StatelessWidget {
  /// {@macro puzzle_export_button}
  const SimplePuzzleExportButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: BlocProvider.of<PuzzleBloc>(context).state.multiplayerStatus == MultiplayerStatus.loading
          ? () {}
          : () => BlocProvider.of<PuzzleBloc>(context).add(
                const PuzzleExport(),
              ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocProvider.of<PuzzleBloc>(context).state.multiplayerStatus == MultiplayerStatus.loading
              ? const CircularProgressIndicator()
              : Image.asset(
                  'assets/images/shuffle_icon.png',
                  width: 17,
                  height: 17,
                ),
          const Gap(10),
          const Text('Export'),
        ],
      ),
    );
  }
}
