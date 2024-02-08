import 'package:flutter/material.dart';
import 'package:video_timeline_edittor/src/models/trim_style.dart';
import 'package:video_timeline_edittor/src/widgets/trim/trim_slider_painter.dart';

class TimelineView extends StatefulWidget{
  createState() => timelineviewstate();
}

class timelineviewstate extends State<TimelineView>{
  List<Widget> mediacomponentlist = [
    Container(
      color: Colors.red,),
    Container(
      color: Colors.green,),
    Container(
      color: Colors.blue,),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List.generate(mediacomponentlist.length, (index) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: mediacomponentlist[index])),
                ),
              ),
            ),
          ),
          GestureDetector(
            // onHorizontalDragStart: _onHorizontalDragStart,
            // onHorizontalDragUpdate: _onHorizontalDragUpdate,
            // onHorizontalDragEnd: _onHorizontalDragEnd,
            behavior: HitTestBehavior.opaque,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                // widget.controller,
                // widget.controller.video,
              ]),
              builder: (_, __) {
                return RepaintBoundary(
                  child: CustomPaint(
                    size:Size.infinite,
                    painter: TrimSliderPainter(
                      Rect.zero,
                     22.0,
                      TrimSliderStyle(
                      ),
                      isTrimming:false,
                      isTrimmed:false,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: List.generate(mediacomponentlist.length, (index) => Container()),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}