// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sparkle_flutter/sparkle_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              print("Checking updates");
              SparkleFlutter.checkForUpdates(inBackground: true);
            },
            child: const Text("Check update"),
          ),
        ),
      ),
    );
  }
}
