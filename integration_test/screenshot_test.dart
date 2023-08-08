import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pipelines/main.dart' as app;
import 'package:flutter_pipelines/screens/second_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
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

    testWidgets('render home', (tester) async {
      await testRenderHome(tester, binding);
    });
    testWidgets('render second screen', (tester) async {
      await testRenderSecond(tester, binding);
    });
  });
}

Future<void> testRenderHome(
    WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  app.main();
  await tester.pumpAndSettle();
  await binding.takeScreenshot('0-home');
}

Future<void> testRenderSecond(
    WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  await tester.pumpWidget(const MaterialApp(home: SecondScreen()));
  await tester.pumpAndSettle();
  await binding.takeScreenshot('1-second');
}
