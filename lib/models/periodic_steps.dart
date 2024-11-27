import 'dart:developer';
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'dart:async';

import 'package:steps_tracker/state/steps_tracker_cubit.dart';

class PeriodicSteps extends StepTrackerCubit {
  int? dailySteps;
  final now = DateTime.now();

  void finalDailySteps() {
    reset();
    StepTrackerCubit().initialize();
    StepTrackerModel().dispose();
  }
}
// }
