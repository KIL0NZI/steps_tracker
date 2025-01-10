import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_tracker/firebase_options.dart';
import 'package:steps_tracker/screens/auth_screen.dart';
import 'package:steps_tracker/state/steps_tracker_cubit.dart';
import 'package:steps_tracker/tabs/home_page_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isNew = prefs.getBool('isNew') ?? true;
  if (isNew) {
    prefs.setBool('isNew', false);
    log('First time?');
  }
  else{
    log("I'm not exactly a newcomer tho");
  }

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
        providers: [
          BlocProvider(create: (_) => StepTrackerCubit()),
        ],
        child:
            // isNew
            //     ?
            MaterialApp(
          home: isNew? AuthScreen():HomeScreen(),
          debugShowCheckedModeBanner: false,
        )
        // : App(),
        ),
  );
}
