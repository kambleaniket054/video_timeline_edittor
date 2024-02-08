import Flutter
import UIKit

public class SwiftVideoTimelineEdittorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "video_timeline_edittor", binaryMessenger: registrar.messenger())
    let instance = SwiftVideoTimelineEdittorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
