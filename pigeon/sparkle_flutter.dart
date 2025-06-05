import 'package:pigeon/pigeon.dart';

// dart run pigeon --input pigeon/sparkle_flutter.dart
@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'universal_ble',
    dartOut: 'lib/src/sparkle_flutter.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'macos/Classes/SparkleFlutter.g.swift',
    swiftOptions: SwiftOptions(),
    debugGenerators: true,
  ),
)
/// Flutter -> Native
@HostApi()
abstract class SparkleFlutterChannel {
  void initialize({String? feedUrl});
  void checkForUpdates({bool? inBackground});
  void setScheduledCheckInterval(int interval);
  void automaticallyChecksForUpdates(bool automaticallyChecks);
  void automaticallyDownloadsUpdates(bool automaticallyDownloads);
  bool canCheckForUpdates();
  bool sessionInProgress();
  void addUpdateCheckOptionInAppMenu({String? title, String? menuName});
}

/// Native -> Flutter
@FlutterApi()
abstract class SparkleFlutterCallbackChannel {
  void onUpdaterError(String? error);
  void onUpdaterCheckingForUpdate(Appcast? appcast);
  void onUpdaterUpdateAvailable(AppcastItem? appcastItem);
  void onUpdaterUpdateNotAvailable(String? error);
  void onUpdaterUpdateDownloaded(AppcastItem? appcastItem);
  void onUpdaterBeforeQuitForUpdate(AppcastItem? appcastItem);
  void onUpdateDidFinishUpdateCycle(UpdateCheckEvent event, String? error);
}

class Appcast {
  final List<AppcastItem> items;
  const Appcast({required this.items});
}

class AppcastItem {
  final String? versionString;
  final String? displayVersionString;
  final String? fileURL;
  final int? contentLength;
  final String? infoURL;
  final String? title;
  final String? dateString;
  final String? releaseNotesURL;
  final String? itemDescription;
  final String? itemDescriptionFormat;
  final String? fullReleaseNotesURL;
  final String? minimumSystemVersion;
  final bool? minimumOperatingSystemVersionIsOK;
  final String? maximumSystemVersion;
  final bool? maximumOperatingSystemVersionIsOK;
  final String? channel;

  const AppcastItem({
    this.versionString,
    this.displayVersionString,
    this.fileURL,
    this.contentLength,
    this.infoURL,
    this.title,
    this.dateString,
    this.releaseNotesURL,
    this.itemDescription,
    this.itemDescriptionFormat,
    this.fullReleaseNotesURL,
    this.minimumSystemVersion,
    this.minimumOperatingSystemVersionIsOK,
    this.maximumSystemVersion,
    this.maximumOperatingSystemVersionIsOK,
    this.channel,
  });
}

enum UpdateCheckEvent {
  checkUpdates,
  checkUpdatesInBackground,
  checkUpdateInformation,
}
