import 'dart:io';

class SignUpdateResult {
  const SignUpdateResult({required this.signature, required this.length});

  final String signature;
  final int length;
}

SignUpdateResult signUpdate(List<String> args) {
  String executable =
      '${Directory.current.path}/macos/Pods/Sparkle/bin/sign_update';
  List<String> arguments = List<String>.from(args);
  ProcessResult processResult = Process.runSync(executable, arguments);
  int exitCode = processResult.exitCode;
  String? signUpdateOutput;
  if (exitCode == 0) {
    signUpdateOutput = processResult.stdout.toString();
    stdout.write(signUpdateOutput);
  } else {
    stderr.write(processResult.stderr);
  }
  RegExp regex = RegExp(r'sparkle:(dsa|ed)Signature="([^"]+)" length="(\d+)"');
  RegExpMatch? match = regex.firstMatch(signUpdateOutput!);

  if (match == null) {
    throw Exception('Failed to sign update');
  }
  return SignUpdateResult(
    signature: match.group(2)!,
    length: int.tryParse(match.group(3)!)!,
  );
}

Future<void> main(List<String> args) async {
  if (!Platform.isMacOS) {
    throw UnsupportedError('sparkle_flutter:sign_update');
  }
  signUpdate(args);
}
