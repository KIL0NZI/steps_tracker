import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';

class StepTrackerModel {

  // Stream controllers
  Stream<StepCount> _stepCountStream = const Stream.empty();
  Stream<PedestrianStatus> _pedestrianStatusStream = const Stream.empty();

  // Public stream getters
  Stream<StepCount> get stepCountStream => _stepCountStream;
  Stream<PedestrianStatus> get pedestrianStatusStream =>
      _pedestrianStatusStream;

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
        print('Permission status: $status');
        if (!status.isGranted) {
          throw Exception('Permission denied');
        }
      }

      // Initialize the stream controller
      _stepController = StreamController<int>.broadcast();
      
      // Initialize the pedometer streams
      _stepCountStream = await Pedometer.stepCountStream;
      print('Step count stream initialized');
      _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;

      // Listen to the step count stream
      _stepCountStream.listen((StepCount event) {
        print('Steps received: ${event.steps}');
        _steps = event.steps;
        _stepController?.add(_steps);
      }).onError((error) {
        print('Error in step count stream: $error');
      });
    } catch (error) {
      print('Error initializing step tracker: $error');
      rethrow;
    }
  }

  // Add dispose method
  void dispose() {
    _stepController?.close();
  }
}
