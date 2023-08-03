import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pipelines/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  print('DEVICE_NAME: ${const String.fromEnvironment('DEVICE_NAME')}');
  group('Screenshot tests', () {
    setUpAll(() {
      return Future(() async {
        WidgetsApp.debugAllowBannerOverride = false; // Hide the debug banner
        if (Platform.isAndroid) {
          await binding.convertFlutterSurfaceToImage();
        }
        print("set up complete");
      });
    });
    testWidgets('render home and navigate', (tester) async {
      print("starting main");
      app.main();
      print("main started");
      await tester.pumpAndSettle();
      await binding.takeScreenshot('0-home');
      print("screenshot taken");
    });
  });
}
