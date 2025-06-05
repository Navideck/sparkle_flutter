import Cocoa
import FlutterMacOS

public class SparkleFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    #if ENABLE_SPARKLE
      let messenger: FlutterBinaryMessenger = registrar.messenger
      let callbackChannel = SparkleFlutterCallbackChannel(binaryMessenger: messenger)
      let api = SparkleFlutterImpl(callbackChannel: callbackChannel)
      SparkleFlutterChannelSetup.setUp(binaryMessenger: messenger, api: api)
    #endif
  }
}
