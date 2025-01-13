import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'package:steps_tracker/services/permission_service.dart';

class StepTrackerCubit extends Cubit<int> {
  final StepTrackerModel _stepTrackerModel = StepTrackerModel();

  StepTrackerCubit() : super(0) {
    initialize();
  }

  void initialize() async {
    final hasPermission = await PermissionsService.requestStepPermissions();
    if (hasPermission) {
      log('Permission granted');
      await _stepTrackerModel.initialize();
      _stepTrackerModel.stepCountStream.listen((event) {
        emit(event); // Emit the current step count
        log('Todays steps are $event');
      });
    } else {
      log('Permission denied');
    }
  }

  void reset() {
    _stepTrackerModel.resetSteps(); // Reset the steps in the model
    emit(0); // Emit zero to the state
    log('Steps reset to 0');
  }

  @override
  Future<void> close() {
    _stepTrackerModel.dispose(); // Ensure to clean up resources if needed
    return super.close();
  }
}
