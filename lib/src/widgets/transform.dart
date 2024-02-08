import 'package:flutter/material.dart';
import 'package:video_timeline_edittor/src/models/transform_data.dart';

class CropTransform extends StatelessWidget {
  var key;
   CropTransform({
    this.key,
    required this.transform,
    required this.child,
  }):super(key: key);

  final Widget child;
  final TransformData transform;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        child: Transform.rotate(
          angle: transform.rotation,
          child: Transform.scale(
            scale: transform.scale,
            child: Transform.translate(
              offset: transform.translate,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// [CropTransform] with rotation animation
class CropTransformWithAnimation extends StatelessWidget {
  var key;

   CropTransformWithAnimation({
    this.key,
    required this.transform,
    required this.child,
    this.shouldAnimate = true,
  }):super(key: key);

  final Widget child;
  final TransformData transform;

  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    if (shouldAnimate == false) {
      return CropTransform(transform: transform, child: child);
    }

    return RepaintBoundary(
      child: AnimatedRotation(
        // convert rad to turns
        turns: transform.rotation * (57.29578 / 360),
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        child: Transform.scale(
          scale: transform.scale,
          child: Transform.translate(
            offset: transform.translate,
            child: child,
          ),
        ),
      ),
    );
  }
}
