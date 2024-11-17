import 'package:flutter/material.dart';
import 'package:steps_tracker/models/new_user.dart';
import 'package:steps_tracker/models/permission_service.dart';
import 'package:steps_tracker/screens/auth_screen.dart';
import 'package:steps_tracker/tabs/home_page_tab.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    final hasPermission = await PermissionsService.requestStepPermissions();
    if (hasPermission) {
      debugPrint('Permission granted');
      // Initialize your step tracking here
    } else {
      debugPrint('Permission denied');
    }

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    NewUser newUser = NewUser();
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
