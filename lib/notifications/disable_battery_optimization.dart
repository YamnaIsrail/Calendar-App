import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

import '../main.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> disableBatteryOptimization() async {
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

    if (androidInfo.version.sdkInt >= 23) {
      bool isIgnoring = await Permission.ignoreBatteryOptimizations.isGranted;

      if (!isIgnoring) {
        // await Permission.ignoreBatteryOptimizations.request();
        isIgnoring = await Permission.ignoreBatteryOptimizations.isGranted;
      }

      if (!isIgnoring) {
        navigatorKey.currentState?.overlay?.context
            ?.findAncestorStateOfType<NavigatorState>()
            ?.push(
          MaterialPageRoute(
            builder: (context) => BatteryOptimizationDialog(),
          ),
        );
      }
    }
  }
}

class BatteryOptimizationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Disable Battery Optimization"),
      content: const Text(
          "To ensure notifications work properly, please disable battery optimization for this app."
              "\n\nClick the button below to go to settings and disable it manually."
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            AppSettings.openAppSettings(type: AppSettingsType.batteryOptimization);
            Navigator.of(context).pop();
          },
          child: const Text("Open Settings"),
        ),
      ],
    );
  }
}
