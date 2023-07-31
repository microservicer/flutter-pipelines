import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  String deviceName = Platform.environment['DEVICE_NAME'] ?? '';
  String devicePrefix = deviceName.isEmpty ? '' : '${deviceName}_';
  await integrationDriver(
    onScreenshot: (String screenshotName, List<int> screenshotBytes,
        [Map<String, Object?>? json]) async {
      final File image =
          await File('screenshots/$devicePrefix$screenshotName.png')
              .create(recursive: true);
      image.writeAsBytesSync(screenshotBytes);
      return true;
    },
  );
}
