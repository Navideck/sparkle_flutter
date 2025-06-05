import 'package:sparkle_flutter/src/sparkle_flutter.g.dart';

class SparkleFlutter {
  static final _channel = SparkleFlutterChannel();

  static void setFeedURL(String url) => _channel.setFeedURL(url);

  static void checkForUpdates({bool? inBackground}) =>
      _channel.checkForUpdates(inBackground: inBackground);

  static void setScheduledCheckInterval(int interval) =>
      _channel.setScheduledCheckInterval(interval);
}
