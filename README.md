# Sparkle Flutter

This plugin allows Flutter desktop apps to automatically update themselves (based on sparkle).

## Getting Started

By default Sparkle will not be part of your app, so you have to first set env `ENABLE_SPARKLE=1` in your terminal,

After adding this plugin, either export `ENABLE_SPARKLE=1` to your terminal, or run all commands with this env,

```sh
flutter clean
cd macos
ENABLE_SPARKLE=1 pod install
```

This will include the sparkle framework in your app

To remove Sparkle framework, repeat these commands, without env

```sh
flutter clean
cd macos
pod install
```

## Usage

```dart
import 'package:sparkle_flutter/sparkle_flutter.dart';

void main() async {
  // Must add this line.
  WidgetsFlutterBinding.ensureInitialized();

  String feedURL = 'http://localhost:5002/appcast.xml';
  await SparkleFlutter.initialize(feedUrl: feedUrl);
  await SparkleFlutter.checkForUpdates();
  await SparkleFlutter.setScheduledCheckInterval(3600);

  runApp(MyApp());
}
```

Please see the example app of this plugin for a full example.

## Publish your app

### Generate private key

Run the following command:

```sh
dart run sparkle_flutter:generate_keys
```

Prepare signing with EdDSA signatures, and add that in your info.plist file

Output:

```sh
A key has been generated and saved in your keychain. Add the `SUPublicEDKey` key to
the Info.plist of each app for which you intend to use Sparkle for distributing
updates. It should appear like this:

    <key>SUPublicEDKey</key>
    <string>pfIShU4dEXqPd5ObYNfDBiQWcXozk7estwzTnF9BamQ=</string>
```

### Build Update

build your flutter mac app first with: `flutter build macos`

Get your app: `YOUR_MAC_APP_NAME.app`

Install `7zip`

```sh
brew install p7zip
```

zip it with `7zip`

```sh
7z a "OUTPUT_UPDATE_NAME" "YOUR_MAC_APP_NAME.app/*"
```

### Get signature

Run the following command:

```sh
dart run sparkle_flutter:sign_update YOUR_MAC_APP_ZIP_FILE_PATH.zip
```

Output:

```sh
sparkle:edSignature="pbdyPt92pnPkzLfQ7BhS9hbjcV9/ndkzSIlWjFQIUMcaCNbAFO2fzl0tISMNJApG2POTkZY0/kJQ2yZYOSVgAA==" length="13400992"
```

Update the obtained new signature to the value of the `sparkle:edSignature` attribute of the enclosure node of the appcast.xml file.

```xml
 <item>
    <title>Version 1.1.0</title>
    <sparkle:releaseNotesLink>
        https://your_domain/your_path/release_notes.html
    </sparkle:releaseNotesLink>
    <pubDate>Sun, 16 Feb 2025 12:00:00 +0800</pubDate>
    <enclosure
            url="your update zip url"
            sparkle:version="1.1.0+2"
            sparkle:os="macos"
            sparkle:dsaSignature="ADD YOUR SIGNATURE HERE"
            length="ADD LENGTH HERE"
            type="application/octet-stream" />
</item>
```

## Related Links

[https://sparkle-project.org/](https://sparkle-project.org/)
