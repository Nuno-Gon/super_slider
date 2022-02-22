import 'dart:convert';

import 'package:image/image.dart';
import 'package:json_annotation/json_annotation.dart';

/// Custom Imglib.Image Json converter
class CustomImglibImageConverter
    implements JsonConverter<Image?, Map<String, dynamic>?> {
  /// Constructor
  const CustomImglibImageConverter();

  @override
  Image? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return decodeImage(base64Decode(json['content'] as String));
  }

  @override
  Map<String, dynamic>? toJson(Image? image) {
    if (image == null) {
      return null;
    }

    return <String, dynamic>{
      'content': base64Encode(
        encodeJpg(
          image,
          quality: 50,
        ),
      ),
      'height': image.height,
      'width': image.width,
    };
  }
}
