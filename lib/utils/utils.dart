import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_lib;
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
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

/// Shows snackbar based on Sharing Status
void sharingListener(PuzzleState state, BuildContext context) {
  var msg = '';

  switch (state.sharingStatus) {
    case SharingStatus.errorExport:
      msg = context.l10n.puzzleExportError;
      break;
    case SharingStatus.errorImport:
      msg = context.l10n.puzzleImportError;
      break;

    //ignore: no_default_cases
    default:
      break;
  }

  if (msg.isNotEmpty) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
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
