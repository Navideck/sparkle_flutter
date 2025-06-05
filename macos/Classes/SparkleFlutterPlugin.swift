import Cocoa
import FlutterMacOS

public class SparkleFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger: FlutterBinaryMessenger = registrar.messenger
    #if ENABLE_SPARKLE
      let callbackChannel = SparkleFlutterCallbackChannel(binaryMessenger: messenger)
      let api = SparkleFlutterImpl(callbackChannel: callbackChannel)
      SparkleFlutterChannelSetup.setUp(binaryMessenger: messenger, api: api)
    #else
      SparkleFlutterChannelSetup.setUp(binaryMessenger: messenger, api: SparkleFlutterImplStub())
    #endif
  }
}
