import 'dart:async';
import 'package:flutter/material.dart';

Future<Size> getImageSize(String url) async {
  final completer = Completer<Size>();
  final img = NetworkImage(url);
  img
      .resolve(const ImageConfiguration())
      .addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          final size = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
          completer.complete(size);
        }),
      );
  return completer.future;
}
