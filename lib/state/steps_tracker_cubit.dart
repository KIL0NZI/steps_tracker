import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'package:steps_tracker/services/permission_service.dart';

class StepTrackerCubit extends Cubit<int> {
  final StepTrackerModel _stepTrackerModel = StepTrackerModel();

  StepTrackerCubit() : super(0) {
    _initialize();
  }

  void _initialize() async {
    // Retrieve saved steps from persistent storage.
    final prefs = await SharedPreferences.getInstance();
    final savedSteps = prefs.getInt('savedSteps') ?? 0;
    emit(savedSteps); // Emit the persisted count as the initial state.

    final hasPermission = await PermissionsService.requestStepPermissions();
    if (hasPermission) {
      log('Permission granted');
      await _stepTrackerModel.initialize();
      _stepTrackerModel.stepCountStream.listen((event) {
        if (event > savedSteps) {
          emit(event);
          log('Steps updated: $event');
          _saveSteps(event);
        } // Save steps to storage for persistence.
      });
    } else {
      log('Permission denied');
    }
  }

  void reset() {
    _stepTrackerModel.resetSteps();
    emit(0);
    log('Steps reset');
  }

  /// Persists the current step count and updates daily step tracking.
  ///
  /// This method:
  /// - Stores the current step count as 'currentSteps'.
  /// - Checks if today's date matches the stored baseline date.
  ///   - If not, it resets the baseline (stored as 'baselineSteps') and sets 'dailySteps' to 0.
  ///   - Otherwise, it computes daily steps by subtracting the baseline from the current count.
  /// - Also stores the overall count under 'savedSteps' (for backward compatibility if needed).
  Future<void> _saveSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();

    // Save the current step count.
    prefs.setInt('currentSteps', steps);

    // Get today's date in YYYY-MM-DD format.
    final today = DateTime.now().toIso8601String().substring(0, 10);
    // Retrieve the stored baseline date or default to today if not set.
    final storedDate = prefs.getString('baselineDate') ?? today;
    log('Stored date: $storedDate, Today: $today');

    if (storedDate != today) {
      // It's a new day: reset the baseline and daily steps.
      prefs.setInt('baselineSteps', steps);
      prefs.setString('baselineDate', today);
      prefs.setInt('dailySteps', 0);
      log('New day detected. Baseline reset to $steps for $today');
    } else {
      // Compute daily steps as the difference between current steps and the baseline.
      final baseline = prefs.getInt('baselineSteps') ?? steps;
      final dailySteps = steps - baseline;
      prefs.setInt('dailySteps', dailySteps);
      log('Daily steps updated: $dailySteps (Current: $steps, Baseline: $baseline)');
    }

    // Optionally, keep a separate record of the overall saved steps.
    prefs.setInt('savedSteps', steps);
  }

  @override
  Future<void> close() {
    _stepTrackerModel.dispose();
    return super.close();
  }
}
