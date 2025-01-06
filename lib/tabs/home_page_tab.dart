import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steps_tracker/models/progress_bar.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'package:steps_tracker/state/steps_tracker_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    StepTrackerModel().initialize();
    // StepTrackerCubit().initialize();
    // StepTrackerCubit().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 400.0,
            toolbarHeight: 100.0,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              var appBarHeight = constraints.biggest.height;
              isExpanded = appBarHeight > 150;

              return FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade400, Colors.white],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<StepTrackerCubit, int>(
                          builder: (context, steps) {
                            log("Homescreen steps: $steps");
                            final int targetSteps = 10000;
                            final double progress =
                                (steps / targetSteps).clamp(0.0, 1.0);
                            return Column(children: [
                              SizedBox(
                                height: 100.0,
                              ),
                              Container(
                                width: 200.0,
                                child: CustomCircularProgressIndicator(
                                  progress: progress,
                                  strokeWidth: 25.0,
                                  innerRadius: 50.0,
                                  progressColor: Colors.blue,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 100.0,
                              ),
                              Text(
                                '$steps',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]);
                          },
                        ),
                        const Text(
                          'steps',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ];
      },
      body: Center(
        child: Container(
          color: Colors.white,
          // padding: EdgeInsets.all(200.0), // Optional: adds background color
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: () {
                      // TODO: Add reset logic here
                      context.read<StepTrackerCubit>().reset();
                    },
                    child: Text('Reset'))
              ]),
        ),
      ),
    ));
  }

  Widget leaderBoard() {
    List<TableRow> rows = [];
    for (int i = 0; i < 100; i++) {
      rows.add(TableRow(children: [
        Text("number " + i.toString()),
        Text("squared " + (i * i).toString()),
      ]));
    }
    return Table(
      children: rows,
    );
  }
}
