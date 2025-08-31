import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ai_edge_sdk/ai_edge_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _aiEdgeSdk = AiEdgeSdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Check device support and get device info
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      final deviceInfo = await _aiEdgeSdk.getDeviceInfo();
      final isSupported = await _aiEdgeSdk.isSupported();

      platformVersion =
          'Device: ${deviceInfo.manufacturer} ${deviceInfo.model}\n'
          'Android: ${deviceInfo.androidVersion}\n'
          'Pixel 9 Series: ${deviceInfo.isPixel9Series}\n'
          'AICore Available: ${deviceInfo.isAiCoreAvailable}\n'
          'Supported: $isSupported\n'
          'Status: ${deviceInfo.compatibilityStatus}';
    } on Exception catch (e) {
      platformVersion = 'Error: $e';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              _platformVersion,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
