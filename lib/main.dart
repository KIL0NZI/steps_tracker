import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_tracker/app.dart';
import 'package:steps_tracker/firebase_options.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'package:steps_tracker/screens/auth_screen.dart';
import 'package:steps_tracker/screens/landing_screen.dart';
import 'package:steps_tracker/services/permission_service.dart';
import 'package:steps_tracker/state/steps_tracker_cubit.dart';
import 'package:steps_tracker/tabs/home_page_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isNew = prefs.getBool('isNew') ?? true;
  if (isNew) {
    prefs.setBool('isNew', true);
  }

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final hasPermission = await PermissionsService.requestStepPermissions();
  if (hasPermission) {
    log('Permission granted');
    // Initialize your step tracking here
    await StepTrackerModel().initialize();
  } else {
    log('Permission denied');
  }

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => StepTrackerCubit()),
      ],
      child: 
      // isNew
      //     ? 
          MaterialApp(
              home: HomeScreen(),
              debugShowCheckedModeBanner: false,
            )
          // : App(),
    ),
  );
}
