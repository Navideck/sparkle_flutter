// ignore_for_file: avoid_print

import 'dart:io';

Future<void> main(List<String> arguments) async {
  if (!Platform.isMacOS) {
    throw UnsupportedError('sparkle_flutter:verify_sparkle');
  }

  String sparkleFolder = '${Directory.current.path}/macos/Pods/Sparkle';
  Directory sparklePod = Directory(sparkleFolder);
  if (!sparklePod.existsSync()) {
    print("Sparkle Directory exists");
  } else {
    print("Sparkle pod not installed");
  }
}
