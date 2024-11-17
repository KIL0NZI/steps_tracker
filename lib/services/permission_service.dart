import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static Future<bool> requestStepPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.activityRecognition.status;
      log('Android Activity Recognition Permission status: $status');

      if (status.isDenied) {
        status = await Permission.activityRecognition.request();
        log('Android Activity Recognition Permission requested: $status');
      }

      return status.isGranted;
    }

    if (Platform.isIOS) {
      var status = await Permission.sensors.status;
      log('iOS Sensors Permission status: $status');

      if (status.isDenied) {
        status = await Permission.sensors.request();
        log('iOS Sensors Permission requested: $status');
      }

      return status.isGranted;
    }

    return false;
  }
}
