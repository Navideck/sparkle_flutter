import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  if (!Platform.isMacOS) {
    throw UnsupportedError('sparkle_flutter:generate_keys');
  }

  String executable =
      '${Directory.current.path}/macos/Pods/Sparkle/bin/generate_keys';

  Process process = await Process.start(executable, arguments);
  process.stdout.transform(utf8.decoder).listen(stdout.write);
  process.stderr.transform(utf8.decoder).listen(stderr.write);
}
