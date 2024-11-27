import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';

class StepTrackerCubit extends Cubit<int> {
  final StepTrackerModel _stepTrackerModel = StepTrackerModel();

  StepTrackerCubit() : super(0) {
    initialize();
  }

  void initialize() async {
    await _stepTrackerModel.initialize();
    _stepTrackerModel.stepCountStream.listen((event) {
      if (state != event.steps) {
      }
      log(' Todays steps are $event');
    });
  }
  //dont even know what I was trying and catching here...maybe I should catch some bitches
  void reset() {
    try {
      emit(0);
      log('steps reset to 0');
      _stepTrackerModel.dispose();
    } catch (error) {
      log('error bro $error');
    }
  }
}
