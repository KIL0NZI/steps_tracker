import 'package:steps_tracker/state/steps_tracker_cubit.dart';

class PeriodicSteps extends StepTrackerCubit {
  int? dailySteps;
  final now = DateTime.now();

  void finalDailySteps() {
    reset();
    StepTrackerCubit().initialize();}
}
// }
