import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'dart:developer';

class StepTrackerModel {
  StreamSubscription<StepCount>? _stepCountSubscription;
  int _steps = 0;
  StreamController<int>? _stepController;

  Stream<int> get stepCountStream =>
      _stepController?.stream ?? const Stream.empty();

  int get steps => _steps;

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

      _stepCountSubscription =
          Pedometer.stepCountStream.listen((StepCount event) {
        _steps = event.steps;
        _stepController?.add(_steps);
      }, onError: (error) {
        log('Error in step count stream: $error');
      });
    } catch (error) {
      log('Error initializing step tracker: $error');
      rethrow;
    }
  }

  void resetSteps() async {
    // Set everything to null or reset values
    _stepCountSubscription?.cancel();
    _stepCountSubscription = null;
    _steps = 0;
    _stepController?.close();
    _stepController = null;

    log("Steps have been reset");

    // Reinitialize to start listening again
    await initialize();
  }

  Future<void> dispose() async {
    await _stepCountSubscription?.cancel();
    await _stepController?.close();
  }
}
