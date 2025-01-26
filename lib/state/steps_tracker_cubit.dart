import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'package:steps_tracker/services/permission_service.dart';
import 'package:workmanager/workmanager.dart';

class StepTrackerCubit extends Cubit<int> {
  final StepTrackerModel _stepTrackerModel = StepTrackerModel();

  StepTrackerCubit() : super(0) {
    _initialize();
    _startBackgroundSync();
  }

  void _initialize() async {
    final hasPermission = await PermissionsService.requestStepPermissions();
    if (hasPermission) {
      log('Permission granted');
      await _stepTrackerModel.initialize();
      _stepTrackerModel.stepCountStream.listen((event) {
        emit(event); // Emit the current step count
        log('Steps updated: $event');
        _saveSteps(event); // Save steps to storage for persistence
      });
    } else {
      log('Permission denied');
    }
  }

  void _startBackgroundSync() {
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      "syncSteps",
      "stepBackgroundTask",
      frequency: const Duration(minutes: 15),
    );
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((taskName, inputData) async {
      log('Background task running');
      //TODO: Fetch steps here using platform API (e.g., Google Fit or CMPedometer)
      return Future.value(true);
    });
  }

  void reset() {
    _stepTrackerModel.resetSteps();
    emit(0);
    log('Steps reset');
  }

  Future<void> _saveSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('savedSteps', steps);
  }

  @override
  Future<void> close() {
    _stepTrackerModel.dispose();
    return super.close();
  }
}
