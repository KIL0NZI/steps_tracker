import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'dart:developer';

class StepTrackerModel {
  StreamSubscription<StepCount>? _stepCountSubscription;
  int _initialSteps = -1;
  int _currentSteps = 0;
  StreamController<int>? _stepController;

  Stream<int> get stepCountStream =>
      _stepController?.stream ?? const Stream.empty();

  int get steps => _initialSteps == -1 ? 0 : _currentSteps - _initialSteps;

  Future<void> initialize() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.activityRecognition.request();
        log('Permission status: $status');
        if (!status.isGranted) {
          throw Exception('Permission denied');
        }
      }

      _stepController = StreamController<int>.broadcast();
      await _initializeStepCounting();
    } catch (error) {
      log('Error initializing step tracker: $error');
      rethrow;
    }
  }

  Future<void> _initializeStepCounting() async {
    _stepCountSubscription =
        Pedometer.stepCountStream.listen((StepCount event) {
      if (_initialSteps == -1) {
        _initialSteps = event.steps;
      }
      _currentSteps = event.steps;
      final currentSteps = _currentSteps - _initialSteps;
      _stepController?.add(currentSteps);
    }, onError: (error) {
      log('Error in step count stream: $error');
    });
  }

  Future<void> resetSteps() async {
    try {
      await _stepCountSubscription?.cancel();
      _stepCountSubscription = null;

      final currentReading = await Pedometer.stepCountStream.first;
      _initialSteps = currentReading.steps;
      _currentSteps = _initialSteps;
      _stepController?.add(0);

      await _initializeStepCounting();
      log("Steps have been reset");
    } catch (error) {
      log('Error resetting steps: $error');
      rethrow;
    }
  }

  Future<void> dispose() async {
    await _stepCountSubscription?.cancel();
    await _stepController?.close();
    _initialSteps = -1;
    _currentSteps = 0;
  }
}
