import 'dart:convert';
import 'dart:typed_data' show Uint8List;

import 'package:image/image.dart';
import 'package:json_annotation/json_annotation.dart';

///Custom Imglib.Image Json converter
class CustomImglibImageConverter implements JsonConverter<Image?, Map<String, dynamic>?> {
  ///Constructor
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
          quality: 30,
        ),
      ),
      'height': image.height,
      'width': image.width,
    };
  }
}

class Uint8ListConverter implements JsonConverter<Uint8List?, String?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(String? json) {
    if (json == null) {
      return null;
    }

    return base64Decode(json);
  }

  @override
  String? toJson(Uint8List? object) {
    if (object == null) {
      return null;
    }

    return base64Encode(object);
  }
}
