 import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:video_timeline_edittor/timelineView.dart';
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
      videoEditorController = VideoEditorController.file(File(file.path),   minDuration: const Duration(seconds: 1),
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
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2,
            // margin: const EdgeInsets.symmetric(vertical: 60 / 4),
          child: StreamBuilder<bool>(
            stream:rebuildstream.stream,
            initialData: false,
            builder: (context,snapshot){
              if(snapshot.data == false){
                return Container();
              }
              return TimelineView() /*TrimSlider(
                height: 60,
                horizontalMargin: 60 / 4,
                controller: videoEditorController,
                child: TrimTimeline(
                  controller: videoEditorController,
                  padding: const EdgeInsets.only(top: 10),
                ),
              )*/;
            },
          )
        ),
      );
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
    return  MaterialApp(
        home: MyApp());
  }
}
