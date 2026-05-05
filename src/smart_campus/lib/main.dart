import 'package:flutter/material.dart';

import 'package:workmanager/workmanager.dart';
import 'app.dart';

import '/services/notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Background Task Running: $task");
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  Workmanager().registerPeriodicTask(
    "1",
    "fetchDataTask",
    frequency: const Duration(minutes: 15),
  );

  runApp(const SmartCampusApp());
}
