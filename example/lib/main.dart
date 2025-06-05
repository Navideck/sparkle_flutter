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

class _MyAppState extends State<MyApp>
    implements SparkleFlutterCallbackChannel {
  List<String> logs = [];

  // Specify feed url first, and initialize with it
  String feedUrl = "";

  @override
  void initState() {
    SparkleFlutter.setListener(this);
    SparkleFlutter.initialize(feedUrl: feedUrl);
    super.initState();
  }

  void _addLogs(log) {
    setState(() {
      logs.add(log);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SparkleFlutter Example'),
          elevation: 4,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  logs.clear();
                });
              },
              icon: Icon(Icons.clear_all),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      SparkleFlutter.checkForUpdates(inBackground: false);
                    },
                    child: const Text("Check update"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      SparkleFlutter.setAutomaticallyChecksForUpdates(true);
                    },
                    child: const Text("Set AutomaticallyChecksForUpdates"),
                  ),
                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () async {
                      print("Checking updates");
                      bool result = await SparkleFlutter.canCheckForUpdates;
                      _addLogs("CanCheckUpdates: $result");
                    },
                    child: const Text("Can check update"),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(logs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onUpdateDidFinishUpdateCycle(UpdateCheckEvent event, String? error) {
    _addLogs("onUpdateDidFinishUpdateCycle: $event Error: $error");
  }

  @override
  void onUpdaterBeforeQuitForUpdate(AppcastItem? appcastItem) {
    _addLogs("onUpdaterBeforeQuitForUpdate: $appcastItem");
  }

  @override
  void onUpdaterCheckingForUpdate(Appcast? appcast) {
    _addLogs("onUpdaterCheckingForUpdate: $appcast");
  }

  @override
  void onUpdaterError(String? error) {
    _addLogs("onUpdaterError: $error");
  }

  @override
  void onUpdaterUpdateAvailable(AppcastItem? appcastItem) {
    _addLogs("onUpdaterUpdateAvailable: $appcastItem");
  }

  @override
  void onUpdaterUpdateDownloaded(AppcastItem? appcastItem) {
    _addLogs("onUpdaterUpdateDownloaded: $appcastItem");
  }

  @override
  void onUpdaterUpdateNotAvailable(String? error) {
    _addLogs("onUpdaterUpdateNotAvailable: $error");
  }
}
