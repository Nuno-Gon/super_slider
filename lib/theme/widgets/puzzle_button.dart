import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

/// {@template puzzle_button}
/// Displays the puzzle action button.
/// {@endtemplate}
class PuzzleButton extends StatelessWidget {
  /// {@macro puzzle_button}
  const PuzzleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width = 145,
  }) : super(key: key);

  /// Factory for small buttons
  factory PuzzleButton.small({
    required Widget child,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return PuzzleButton(
      width: 100,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onPressed: onPressed,
      child: child,
    );
  }

  /// The background color of this button.
  final Color? backgroundColor;

  /// The text color of this button.
  final Color? textColor;

  /// The width of this button.
  final double? width;

  /// Called when this button is tapped.
  final VoidCallback onPressed;

  /// The label of this button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          primary: textColor,
          backgroundColor: backgroundColor,
          onSurface: backgroundColor,
          textStyle: PuzzleTextStyle.headline5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
