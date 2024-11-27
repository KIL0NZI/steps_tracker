import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'dart:developer';

@override
class StepTrackerModel {
  // Stream controllers
  StreamSubscription? _stepCountSubscription;
  int? finalSteps;
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;

  // Public stream getters
  Stream<StepCount> get stepCountStream =>
      _stepCountStream ?? const Stream.empty();
  Stream<PedestrianStatus> get pedestrianStatusStream =>
      _pedestrianStatusStream ?? const Stream.empty();

  // Add these properties
  int _steps = 0;
  StreamController<int>? _stepController;

  // Add getter for current steps
  int get steps => _steps;

  Future<void> initialize() async {
    try {
      // Request permissions first
      if (Platform.isAndroid) {
        final status = await Permission.activityRecognition.request();
        log('Permission status: $status');
        if (!status.isGranted) {
          throw Exception('Permission denied');
        }
      }
      // Initialize the stream controller
      _stepController = StreamController<int>.broadcast();

      // Initialize the pedometer streams
      _stepCountStream = Pedometer.stepCountStream;
      log('Step count stream initialized');
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      log('Pedestrian status stream initialized');

      // Listen to the step count stream
      _stepCountStream?.listen((StepCount event) {
        // log('Steps received: ${event.steps}');
        _steps = event.steps;
        _stepController?.add(_steps);
      }).

          // _stepCountSubscription = _stepCountStream?.listen((StepCount event) {
          // _steps = event.steps; // Update the steps
          // _stepController?.add(_steps); // Pass steps to the controller
          // });
          onError((error) {
        log('Error in step count stream: $error');
      });
    } catch (error) {
      log('Error initializing step tracker: $error');
      rethrow;
    }
  }

  Future<void> dispose() async {
    finalSteps = steps;
    _stepController?.close();
    _stepController?.sink.add(_steps);
    log('Step tracker disposed completely $finalSteps');
  }
}

  // Add dispose method
  // void dispose() {
  //   _stepController?.close();
  // }

