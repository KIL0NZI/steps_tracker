import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';

class StepTrackerCubit extends Cubit<int> {
  final StepTrackerModel _stepTrackerModel = StepTrackerModel();

  StepTrackerCubit() : super(0) {
    _initialize();
  }

  void _initialize() async {
    await _stepTrackerModel.initialize();
    _stepTrackerModel.stepCountStream.listen((event) {
      emit(event.steps);
    });
  }
}
