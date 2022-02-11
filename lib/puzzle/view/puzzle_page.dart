import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/settings/settings.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/timer/timer.dart';

// ignore: public_member_api_docs
enum PuzzleType { mega, mini }

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(
        themes: const [
          SimpleTheme(),
        ],
      ),
      child: BlocProvider(
        create: (context) => SettingsBloc(),
        child: const PuzzleView(),
      ),
    );
  }
}

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final settings = context.select((SettingsBloc bloc) => bloc.state);

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = theme is SimpleTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: BlocProvider(
        create: (context) => TimerBloc(
          ticker: const Ticker(),
        ),
        child: BlocProvider(
          key: ValueKey(settings),
          create: (context) => PuzzleBloc(
            settings.megaPuzzleSize,
            imageUrl: settings.userImageUrl,
          )..add(
              PuzzleInitialized(
                shufflePuzzle: shufflePuzzle,
              ),
            ),
          child: const _MegaPuzzle(
            key: Key('puzzle_view_puzzle'),
          ),
        ),
      ),
    );
  }
}

class _MegaPuzzle extends StatelessWidget {
  const _MegaPuzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Colors.yellow,
          child: Stack(
            children: [
              theme.layoutDelegate.backgroundBuilder(state),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: GestureDetector(
                          onDoubleTap: () => context.read<PuzzleBloc>().add(
                                const ActiveTileReset(),
                              ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: const _PuzzleHeader(
                              key: Key('puzzle_header'),
                            ),
                          ),
                          const _PuzzleSections(
                            key: Key('puzzle_sections'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// {@template mini_puzzle}
/// Displays the content for the [MiniPuzzle].
/// {@endtemplate}
class MiniPuzzle extends StatelessWidget {
  /// {@macro mini_puzzle}
  const MiniPuzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const PuzzleBoard(
          key: Key('mini_puzzle_sections'),
          puzzleType: PuzzleType.mini,
        );
      },
    );
  }
}

class _PuzzleHeader extends StatelessWidget {
  const _PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'images/our_logo.png',
                      width: 180,
                    ),
                    const Spacer(),
                    const _PuzzleLogo(),
                  ],
                ),
              ),
            ),
            Container(height: 2, color: Colors.black),
          ],
        ),
        Positioned.fill(
          child: GestureDetector(
            onDoubleTap: () => context.read<PuzzleBloc>().add(
                  const ActiveTileReset(),
                ),
          ),
        ),
      ],
    );
  }
}

class _PuzzleLogo extends StatelessWidget {
  const _PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/ctw_logo.png', height: 40),
          const SizedBox(height: 3),
          Row(
            children: [
              Image.asset('images/heart_image.png', height: 15),
              const SizedBox(
                height: 20,
                child: FlutterLogo(
                  style: FlutterLogoStyle.horizontal,
                  size: 86,
                ),
              ),
            ],
          ),
        ],
      ),
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (_) => Row(
        children: [
          Image.asset('images/ctw_logo.png', height: 40),
          const SizedBox(width: 2),
          Image.asset('images/heart_image.png', height: 15),
          const SizedBox(
            height: 20,
            child: FlutterLogo(
              style: FlutterLogoStyle.horizontal,
              size: 86,
            ),
          ),
        ],
      ),
    );
  }
}

class _PuzzleSections extends StatelessWidget {
  const _PuzzleSections({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final settings = context.select((SettingsBloc bloc) => bloc.state);

    return GestureDetector(
      onDoubleTap: () => context.read<PuzzleBloc>().add(
            const ActiveTileReset(),
          ),
      child: ResponsiveLayoutBuilder(
        small: (context, child) => Column(
          children: [
            theme.layoutDelegate.startSectionBuilder(state, settings),
            const PuzzleBoard(
              puzzleType: PuzzleType.mega,
            ),
            theme.layoutDelegate.endSectionBuilder(state, settings),
          ],
        ),
        medium: (context, child) => Column(
          children: [
            theme.layoutDelegate.startSectionBuilder(state, settings),
            const PuzzleBoard(
              puzzleType: PuzzleType.mega,
            ),
            theme.layoutDelegate.endSectionBuilder(state, settings),
          ],
        ),
        large: (context, child) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: theme.layoutDelegate.startSectionBuilder(state, settings),
            ),
            const PuzzleBoard(
              puzzleType: PuzzleType.mega,
            ),
            Expanded(
              child: theme.layoutDelegate.endSectionBuilder(state, settings),
            ),
          ],
        ),
      ),
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  const PuzzleBoard({
    Key? key,
    required this.puzzleType,
  }) : super(key: key);

  /// The type of the puzzle
  final PuzzleType puzzleType;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final settings = context.select((SettingsBloc bloc) => bloc.state);
    final puzzle = puzzleType == PuzzleType.mega
        ? context.select((PuzzleBloc bloc) => bloc.state.puzzle)
        : context.select((MiniPuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0 && puzzleType != PuzzleType.mega) {
      return const SizedBox.shrink();
    }

    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) {
        if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
          context.read<TimerBloc>().add(const TimerStopped());
        }
      },
      child: theme.layoutDelegate.boardBuilder(
        size,
        puzzle.tiles
            .map(
              (tile) => _PuzzleTile(
                key: Key('puzzle_tile_${tile.value.toString()}'),
                isMegaTile: puzzleType == PuzzleType.mega,
                tile: tile,
              ),
            )
            .toList(),
        puzzleType,
        settings,
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
    required this.isMegaTile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;
  final bool isMegaTile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final whitespaceLayout = theme.layoutDelegate.whitespaceTileBuilder();

    final tileLayout = isMegaTile
        ? theme.layoutDelegate.megaTileBuilder(
            tile as MegaTile,
            context.select((PuzzleBloc bloc) => bloc.state),
          )
        : theme.layoutDelegate.miniTileBuilder(
            tile,
            context.select((MiniPuzzleBloc bloc) => bloc.state),
          );

    return tile.isWhitespace ? whitespaceLayout : tileLayout;
  }
}
