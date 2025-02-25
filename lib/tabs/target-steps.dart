import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_tracker/tabs/home_page_tab.dart';

class TargetSteps extends StatefulWidget {
  const TargetSteps({super.key});

  @override
  State<TargetSteps> createState() => _TargetStepsState();
}

class _TargetStepsState extends State<TargetSteps> {
  int _selectedIndex = 5; // Default selection (5000 steps)
  final _targetStepsBox = Hive.box('targetStepsBox');
  List<int> stepValues = List.generate(
      40, (index) => (index + 1) * 1000); // Steps from 1000 to 20000

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStepTarget();
  }

  Future<void> _saveStepTarget(int target) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('step_target', target);
  }

  Future<void> _loadStepTarget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedTarget = prefs.getInt('step_target') ?? 10000;
    setState(() {
      _selectedIndex = stepValues.indexOf(savedTarget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Target Steps: ${stepValues[_selectedIndex]} steps",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 200, // Control height of the wheel picker
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Center(
                    child: Text(
                      "${stepValues[index]} steps",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  );
                },
                childCount: stepValues.length,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (!_targetStepsBox.containsKey('targetsteps')) {
                await _targetStepsBox.put('targetsteps', stepValues[_selectedIndex]);
              } else {
                await _targetStepsBox.put('targetsteps', stepValues[_selectedIndex]);
              }
              _saveStepTarget(stepValues[_selectedIndex]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        "Target set to ${stepValues[_selectedIndex]} steps!")),
              );
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen()));
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9))),
            child: Text("Set Target"),
          ),
        ],
      ),
    );
  }
}
