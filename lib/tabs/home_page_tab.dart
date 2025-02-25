import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_tracker/models/auth.dart';
import 'package:steps_tracker/models/progress_bar.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'package:steps_tracker/state/steps_tracker_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Auth authentication = Auth();
  bool isExpanded = true;

  final _googleUSerBox = Hive.box('googleUSerBox');
  final _userBox = Hive.box('userBox');
  final _targetStepsBox = Hive.box('targetStepsBox');

  late final profilePhoto = _googleUSerBox.get('profilephoto');
  late final userName = _googleUSerBox.get('username');
  late final targetSteps = _targetStepsBox.get('targetsteps');

  void compundingSteps() async {
    SharedPreferences compSteps = await SharedPreferences.getInstance();
  }

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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            expandedHeight: 500.0,
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
                        Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(profilePhoto),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Hello, $userName',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        BlocBuilder<StepTrackerCubit, int>(
                          builder: (context, steps) {
                            log("Homescreen steps: $steps");
                            final finalsteps = steps;
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: leaderBoard(),
      ),
    )
        // Center(
        //   child: Container(
        //     color: Colors.white,
        //     // padding: EdgeInsets.all(200.0), // Optional: adds background color
        //     child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           ElevatedButton(
        //               onPressed: () {
        //                 // TODO: Add reset logic here
        //                 context.read<StepTrackerCubit>().reset();
        //               },
        //               child: Text('Reset'))
        //         ]),
        //   ),
        // ),
        );
  }

  Widget leaderBoard() {
    List<TableRow> rows = [];
    for (int i = 1; i < 101; i++) {
      rows.add(TableRow(children: [
        Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              children: [
                // Stack(
                //   children: [
                // Container(
                //   color: Colors.grey,
                //   decoration: BoxDecoration(shape: BoxShape.circle),
                // ),
                //   ],
                // ),
                Text(
                  i.toString(),
                  style: TextStyle(fontSize: 20),
                ),

                SizedBox(
                  width: 40,
                ),
                Text(
                  "*user*",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            )),
        Padding(
          padding: EdgeInsets.only(left: 50, top: 15, bottom: 15),
          child: BlocBuilder<StepTrackerCubit, int>(builder: (context, steps) {
            return Text(
              '$steps steps',
              style: TextStyle(fontSize: 20),
            );
          }),
        )
      ]));
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Table(
              border: TableBorder.symmetric(

                  // top: BorderSide(color: Colors.blue, width: 2.0),
                  // bottom: BorderSide(color: Colors.blue, width: 2.0),
                  ),
              children: rows,
            ),
          )
        ]);
  }
}
