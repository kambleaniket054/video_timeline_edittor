 import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:video_timeline_edittor/progressbarseek.dart';
import 'package:video_timeline_edittor/video_editor.dart';
import 'package:video_timeline_edittor/video_timeline_edittor.dart';
import 'package:image_picker/image_picker.dart';
void main() {
  runApp(mainApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
 late VideoEditorController videoEditorController;
 StreamController<bool> rebuildstream = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _pickVideo();
  }

  final ImagePicker _picker = ImagePicker();

  void _pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

    if (mounted && file != null) {
      videoEditorController = await VideoEditorController.file(File(file.path),   minDuration: const Duration(seconds: 1),
        maxDuration: const Duration(seconds: 10),);
      rebuildstream.add(true);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => VideoEditor(file: File(file.path)),
      //   ),
      // );
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await VideoTimelineEdittor.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: StreamBuilder<Object>(
            stream:rebuildstream.stream,
            initialData: false,
            builder: (context,snapshot){
              if(snapshot.data == false){
                return Container();
              }
            return Stack(

              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                     margin: const EdgeInsets.symmetric(vertical: 60 / 4),
                  child: TrimSlider(
                    height: 60,
                    horizontalMargin: 60 / 4,
                    controller: videoEditorController,
                    child: TrimTimeline(
                      controller: videoEditorController,
                      padding: const EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              GestureDetector(
              onHorizontalDragStart: _onHorizontalDragStart,
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              behavior: HitTestBehavior.opaque,
              child: AnimatedBuilder(
              animation: Listenable.merge([
                videoEditorController,
                videoEditorController.video,
              ]),
              builder: (_, __) {
              return RepaintBoundary(
                  child: CustomPaint(
                    size: Size(2,MediaQuery.of(context).size.height),
                    painter: TrimprogressPainter(
                      Rect.zero,
                        22.0,
                        videoEditorController.trimStyle,
                      isTrimming: videoEditorController.isTrimming,
                      isTrimmed: videoEditorController.isTrimmed
                    ),
                  ),
                );
              },
              ),
              )
              ],
            );
          }
        ),
      );
  }



  void _onHorizontalDragStart(DragStartDetails details) {
    final pos = details.localPosition;
    final progressTrim =( videoEditorController.startTrim.inMilliseconds + videoEditorController.endTrim.inMilliseconds).toDouble();

    // Left, right and video progress indicator touch areas
    // Rect leftTouch = Rect.fromCenter(
    //   center: Offset(Rect.zero.left - _edgesTouchMargin / 2, _rect.height / 2),
    //   width: _edgesTouchMargin,
    //   height: _rect.height,
    // );
    // Rect rightTouch = Rect.fromCenter(
    //   center: Offset(_rect.right + _edgesTouchMargin / 2, _rect.height / 2),
    //   width: _edgesTouchMargin,
    //   height: _rect.height,
    // );
    // final progressTouch = Rect.fromCenter(
    //   center: Offset(progressTrim, _rect.height / 2),
    //   width: _positionTouchMargin,
    //   height: _rect.height,
    // );
    //
    // // if the scroll view is touched, it will be by default an inside gesture
    // _boundary = _TrimBoundaries.inside;
    //
    // /// boundary should not be set to other that inside when scroll controller is moving
    // /// it would lead to weird behavior to change position while scrolling
    // if (isNotScrollBouncingBack &&
    //     !_scrollController.position.isScrollingNotifier.value) {
    //   if (progressTouch.contains(pos)) {
    //     // video indicator should have the higher priority since it does not affect the trim param
    //     _boundary = _TrimBoundaries.progress;
    //   } else {
    //     // if video indicator is not touched, expand [leftTouch] and [rightTouch] on the inside
    //     leftTouch = leftTouch.expandToInclude(
    //         Rect.fromLTWH(_rect.left, 0, _edgesTouchMargin, 1));
    //     rightTouch = rightTouch.expandToInclude(Rect.fromLTWH(
    //         _rect.right - _edgesTouchMargin, 0, _edgesTouchMargin, 1));
    //   }
    //
    //   if (leftTouch.contains(pos)) {
    //     _boundary = _TrimBoundaries.left;
    //   } else if (rightTouch.contains(pos)) {
    //     _boundary = _TrimBoundaries.right;
    //   }
    // }

    // _updateControllerIsTrimming(true);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    // final Offset delta = details.delta;
    // final posLeft = _rect.topLeft + delta;

    // switch (_boundary) {
    //   case _TrimBoundaries.left:
    //     final clampLeft = posLeft.dx.clamp(_horizontalMargin, _rect.right);
    //     // avoid rect to be out of bounds & avoid minTrim to be bigger than maxTrim
    //     _changeTrimRect(
    //         left: clampLeft,
    //         width: _rect.width - (clampLeft - posLeft.dx).abs() - delta.dx);
    //     break;
    //   case _TrimBoundaries.right:
    //   // avoid rect to be out of bounds & maxTrim to be smaller than minTrim
    //     _changeTrimRect(
    //       width: (_rect.left + _rect.width + delta.dx)
    //           .clamp(_rect.left, _trimLayout.width + _horizontalMargin) -
    //           _rect.left,
    //     );
    //     break;
    //   case _TrimBoundaries.inside:
    //     if (_isExtendTrim) {
    //       _scrollController.position.moveTo(
    //         _scrollController.offset - delta.dx,
    //         clamp: false,
    //       );
    //     } else {
    //       // avoid rect to be out of bounds
    //       _changeTrimRect(
    //         left: posLeft.dx.clamp(
    //           _horizontalMargin,
    //           _trimLayout.width + _horizontalMargin - _rect.width,
    //         ),
    //       );
    //     }
    //     break;
    //   case _TrimBoundaries.progress:
    //     final pos = details.localPosition.dx;
    //     // postion of pos on the layout width between 0 and 1
    //     final localRatio = pos / (_trimLayout.width + _horizontalMargin * 2);
    //     // because the video progress cursor is on a different layout context (horizontal margin are not applied)
    //     // the gesture offset must be adjusted (remove margin when localRatio < 0.5 and add margin when localRatio > 0.5)
    //     final localAdjust = (localRatio - 0.5) * (_horizontalMargin * 2);
    //     _controllerSeekTo((pos + localAdjust).clamp(
    //       _rect.left - _horizontalMargin,
    //       _rect.right + _horizontalMargin,
    //     ));
    //     break;
    //   default:
    //     break;
    // }
  }
   double _touchMargin = 24.0;

  late final _positionTouchMargin =
  max(videoEditorController.trimStyle.positionLineWidth, _touchMargin);

  void _onHorizontalDragEnd([_]) {
  //   _preComputedVideoPosition = null;
  //   _updateControllerIsTrimming(false);
  //   if (_boundary == null) return;
  //   if (_boundary != _TrimBoundaries.progress) {
  //     _updateControllerTrim();
  //   }
  // }
}
}


class mainApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return mainappstate();
  }
}

class mainappstate extends State<mainApp>{
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
        home: MyApp());
  }
}
