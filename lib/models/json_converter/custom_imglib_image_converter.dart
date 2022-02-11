import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart' show Image;
import 'package:image/image.dart' as imglib;
import 'package:json_annotation/json_annotation.dart';

///Custom Imglib.Image Json converter
class CustomImglibImageConverter
    implements JsonConverter<imglib.Image?, Map<String, dynamic>?> {
  ///Constructor
  const CustomImglibImageConverter();

  @override
  imglib.Image? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return imglib.Image.fromBytes(
      json['width'] as int,
      json['height'] as int,
      json['bytes'] as Uint8List,
    );
  }

  @override
  Map<String, dynamic>? toJson(imglib.Image? image) {
    if (image == null) {
      return null;
    }

    return <String, dynamic>{
      'bytes': image.getBytes(),
      'height': image.height,
      'width': image.width,
    };
  }
}

class Uint8ListConverter implements JsonConverter<Uint8List?, List<int>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<int>? json) {
    if (json == null) {
      return null;
    }

    return Uint8List.fromList(json);
  }

  @override
  List<int>? toJson(Uint8List? object) {
    if (object == null) {
      return null;
    }

    return object.toList();
  }
}
