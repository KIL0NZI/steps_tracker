import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For persistence
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'package:steps_tracker/services/permission_service.dart';

class StepTrackerCubit extends Cubit<int> {
  final StepTrackerModel _stepTrackerModel = StepTrackerModel();

  StepTrackerCubit() : super(0) {
    initialize();
  }

  void initialize() async {
    // Load saved step count
    final savedSteps = await _loadSavedSteps();
    emit(savedSteps); // Emit saved steps as initial state

    final hasPermission = await PermissionsService.requestStepPermissions();
    if (hasPermission) {
      log('Permission granted');
      await _stepTrackerModel.initialize();

      _stepTrackerModel.stepCountStream.listen((event) async {
        final totalSteps = savedSteps + event; // Calculate total steps
        emit(totalSteps); // Emit the updated step count
        await _saveSteps(totalSteps); // Save the updated step count
        log('Total steps: $totalSteps');
      });
    } else {
      log('Permission denied');
    }
  }

  void reset() async {
    _stepTrackerModel.resetSteps(); // Reset the steps in the model
    emit(0); // Emit zero to the state
    await _saveSteps(0); // Persist the reset step count
    log('Steps reset to 0');
  }

  // Save steps to local storage
  Future<void> _saveSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('step_count', steps);
    log('Steps saved: $steps');
  }

  // Load steps from local storage
  Future<int> _loadSavedSteps() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSteps = prefs.getInt('step_count') ?? 0;
    log('Loaded saved steps: $savedSteps');
    return savedSteps;
  }

  @override
  Future<void> close() {
    _stepTrackerModel.dispose(); // Ensure to clean up resources if needed
    return super.close();
  }
}
