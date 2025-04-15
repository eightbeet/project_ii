import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AppMethodChannelController {

  static const platform = MethodChannel('method_channel@blocker/background');

  Future<void> startBackgroundMonitoring() async {
    if (await Permission.systemAlertWindow.request().isGranted) {
      try {
        await platform.invokeMethod('startBackgroundService'); // , {'lockedApps': selectedApps});
        // print('Background service started with locked apps: $_selectedApps');
        // print('Background service started with locked apps: $');
      } on PlatformException catch (e) {
        print("Error starting background service: '${e.message}'");
      }
    } else {
      print('Overlay permission not granted.');
      openAppSettings();
    }
  }

  Future<void> stopBackgroundMonitoring() async {
    try {
      await platform.invokeMethod('stopBackgroundService');
      print('Background service stopped.');
    } on PlatformException catch (e) {
      print("Error stopping background service: '${e.message}'");
    }
  }

  Future<void> _requestUsagePermission() async {
    try {
      await platform.invokeMethod('askUsageStatsPermission');
      print('Requested Usage permissions');
    } on PlatformException catch (e) {
      print("Error requesting usage permissions: '${e.message}'");
    }
  }
}

