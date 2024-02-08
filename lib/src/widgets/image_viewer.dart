import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_timeline_edittor/src/controller.dart';

class ImageViewer extends StatelessWidget {
  var key;

   ImageViewer({
    this.key,
    required this.controller,
    required this.bytes,
    this.child,
    this.fadeIn = true,
  }):super(key: key);

  final VideoEditorController controller;
  final Uint8List bytes;
  final Widget? child;
  final bool fadeIn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: controller.video.value.aspectRatio,
            child: fadeIn
                ? FadeInImage(
                    fadeInDuration: const Duration(milliseconds: 400),
                    image: MemoryImage(bytes),
                    placeholder: MemoryImage(kTransparentImage),
                  )
                : Image.memory(
                    bytes,
                    color: const Color.fromRGBO(255, 255, 255, 0.2),
                    colorBlendMode: BlendMode.modulate,
                  ),
          ),
          if (child != null)
            AspectRatio(
              aspectRatio: controller.video.value.aspectRatio,
              child: child,
            ),
        ],
      ),
    );
  }
}
