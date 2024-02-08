import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_timeline_edittor/video_timeline_edittor.dart';

void main() {
  const MethodChannel channel = MethodChannel('video_timeline_edittor');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await VideoTimelineEdittor.platformVersion, '42');
  });
}
