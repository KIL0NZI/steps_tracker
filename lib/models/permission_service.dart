import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class PermissionsService {
  static Future<bool> requestStepPermissions() async {
    if (Platform.isAndroid) {
      // First check if permission is already granted
      var status = await Permission.activityRecognition.status;
      
      if (status.isDenied) {
        status = await Permission.activityRecognition.request();
      }
      
      return status.isGranted;
    }
    
    if (Platform.isIOS) {
      var status = await Permission.sensors.status;
      
      if (status.isDenied) {
        status = await Permission.sensors.request();
      }
      
      return status.isGranted;
    }
    
    return false;
  }
}