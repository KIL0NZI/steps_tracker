import 'package:flutter/material.dart';

class TargetSteps extends StatefulWidget {
  const TargetSteps({super.key});

  @override
  State<TargetSteps> createState() => _TargetStepsState();
}

class _TargetStepsState extends State<TargetSteps> {
  double _targetSteps = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Set Daily Steps Target'),
            SizedBox(
              height: 20,
            ),
            Slider(
              value: _targetSteps,
              min: 1000,
              max: 40000,
              divisions: 19, // Creates steps in multiples of 1000
              label: "${_targetSteps.toInt()}",
              onChanged: (value) {
                setState(() {
                  _targetSteps = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  SnackBar(
                      content:
                          Text("Target set to ${_targetSteps.toInt()} steps!"));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                ),
                child: Text('Set Target'))
          ],
        ),
      ),
    );
  }
}
