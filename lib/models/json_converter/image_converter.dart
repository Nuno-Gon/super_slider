import 'dart:convert';

import 'package:image/image.dart';

/// Custom Image Json Converter
class CustomImglibImageConverter {
  /// Constructor
  const CustomImglibImageConverter();

  ///Converts JSON to Image
  Image? fromJson(String? json) {
    if (json == null) return null;

    return decodeImage(base64Decode(json));
  }

  ///Converts Image to JSON
  String? toJson(Image? image) {
    if (image == null) return null;

    return base64Encode(
      encodeJpg(
        image,
      ),
    );
  }
}
