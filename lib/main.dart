import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_tracker/firebase_options.dart';
import 'package:steps_tracker/state/steps_tracker_cubit.dart';
import 'package:steps_tracker/tabs/home_page_tab.dart';
import 'package:steps_tracker/screens/new_user_screen.dart';
import 'package:workmanager/workmanager.dart';

// This function is called periodically by Workmanager
@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) async {
    // Ensure Flutter bindings are initialized (for background execution)
    WidgetsFlutterBinding.ensureInitialized();

    final prefs = await SharedPreferences.getInstance();

    // Read the saved baseline (the step count at the start of the day)
    final int baseline = prefs.getInt('baselineSteps') ?? 0;
    // Read the current step count (this value should be updated by your active app logic)
    final int currentCount = prefs.getInt('currentSteps') ?? 0;

    // Compute the daily steps
    final int dailySteps = currentCount - baseline;
    prefs.setInt('dailySteps', dailySteps);
    log('Background task: dailySteps = $dailySteps');

    // Check if the day has changed (you can also store the date of the baseline)
    final String storedDate = prefs.getString('baselineDate') ?? '';
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    if (storedDate != today) {
      // It’s a new day – reset the baseline to the current count and update the stored date
      prefs.setInt('baselineSteps', currentCount);
      prefs.setString('baselineDate', today);
      log('New day detected. Baseline reset to $currentCount for $today');
    }

    // Return true to indicate successful completion.
    return await Future.value(true);
  });
}

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox('targetStepsBox');
  await Hive.openBox('googleUSerBox');

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Workmanager and schedule the periodic task.
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "dailyStepCountTask",
    "updateDailySteps",
    frequency: const Duration(minutes: 15), // adjust as needed
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isNew = prefs.getBool('isNew') ?? true;
  if (isNew) {
    prefs.setBool('isNew', false);
    log('First time?');
  } else {
    log("I'm not exactly a newcomer tho");
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => StepTrackerCubit()),
      ],
      child: MaterialApp(
        home: isNew ? HomeScreen() : NewUserScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
