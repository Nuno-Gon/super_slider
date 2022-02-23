import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img_lib;
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';

const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';

/// Game Code Length
const codeLength = 4;

/// Generate unique ID for puzzle export
String generateID({int length = codeLength}) {
  final _rnd = Random();

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(
        _rnd.nextInt(_chars.length),
      ),
    ),
  );
}

// TODO(JR): major refactor needed
/// Shows snackbar based on Multiplayer Status
void multiplayerListener(PuzzleState state, BuildContext context) {
  var msg = '';
  Color? color;

  switch (state.multiplayerStatus) {
    case MultiplayerStatus.initExport:
      break;
    case MultiplayerStatus.loading:
      break;
    case MultiplayerStatus.successExport:
      msg = 'Successfully Exported with code ${state.data}';
      color = Colors.green;
      break;
    case MultiplayerStatus.initImport:
      break;
    case MultiplayerStatus.successImport:
      msg = 'Puzzle Successfully Imported';
      color = Colors.green;
      break;
    case MultiplayerStatus.errorExport:
      msg = 'Could not export your Puzzle!';
      color = Colors.red;
      break;
    case MultiplayerStatus.errorImport:
      msg = 'Could not import the Puzzle! Check your code again.';
      color = Colors.red;
      break;

    // ignore: no_default_cases
    default:
      break;
  }

  if (msg.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          msg,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: color,
        action: state.multiplayerStatus == MultiplayerStatus.successExport
            ? SnackBarAction(
                label: 'Copy to Clipboard',
                textColor: Colors.blue.shade900,
                onPressed: () => Clipboard.setData(
                  ClipboardData(text: '${state.data}'),
                ),
              )
            : null,
      ),
    );
  }
}

///Displays Image from Data
Image displayImage(img_lib.Image? data) => Image.memory(
      Uint8List.fromList(
        data == null ? const <int>[] : img_lib.encodeJpg(data),
      ),
    );

///Converts Json String to Uint8List
Uint8List getJsonUint8List(String json) => Uint8List.fromList(
      utf8.encode(json),
    );
