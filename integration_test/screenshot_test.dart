import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_pipelines/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  enableFlutterDriverExtension();
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Screenshot tests', () {
    setUpAll(() {
      return Future(() async {
        WidgetsApp.debugAllowBannerOverride = false; // Hide the debug banner
        if (Platform.isAndroid) {
          await binding.convertFlutterSurfaceToImage();
        }
      });
    });
    testWidgets('render home and navigate', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await binding.takeScreenshot('0-home');
    });
  });
}
