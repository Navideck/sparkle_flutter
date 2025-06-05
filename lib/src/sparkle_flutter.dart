import 'package:sparkle_flutter/src/sparkle_flutter.g.dart';

class SparkleFlutter {
  static final _channel = SparkleFlutterChannel();

  static void initialize({String? feedUrl}) =>
      _channel.initialize(feedUrl: feedUrl);

  static void checkForUpdates({bool? inBackground}) =>
      _channel.checkForUpdates(inBackground: inBackground);

  static void setScheduledCheckInterval(int interval) =>
      _channel.setScheduledCheckInterval(interval);

  static Future<bool> get canCheckForUpdates => _channel.canCheckForUpdates();

  static Future<bool> get isSessionInProgress => _channel.sessionInProgress();

  static set automaticallyChecksForUpdates(bool value) =>
      _channel.automaticallyChecksForUpdates(value);

  static set automaticallyDownloadsUpdates(bool value) =>
      _channel.automaticallyDownloadsUpdates(value);

  static void setListener(SparkleFlutterCallbackChannel channel) {
    SparkleFlutterCallbackChannel.setUp(channel);
  }
}
