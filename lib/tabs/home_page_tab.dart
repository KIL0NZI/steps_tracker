import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_tracker/main.dart';
import 'package:steps_tracker/models/auth.dart';
import 'package:steps_tracker/models/progress_bar.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'package:steps_tracker/models/user_info_card.dart';
import 'package:steps_tracker/models/users_steps.dart';
import 'package:steps_tracker/state/steps_tracker_cubit.dart';
import 'package:steps_tracker/tabs/steps_actions.dart';

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

  // ignore: non_constant_identifier_names

  // listener: (context, state) async {

  //   // if (state is MyCubitUpdatedState) {
  //   //   // Get current user ID
  //   //   String uid = FirebaseAuth.instance.currentUser!.uid;

  //   //   // Update Firestore with the new state
  //   //   await FirebaseFirestore.instance.collection('users').doc(uid).set({
  //   //     'user': state.value1,
  //   //     'steps': state.value2,
  //   //     // Add other fields as needed
  //   //   });
  //   //   log('Data updated in Firestore');
  //   // }
  // })

  void compundingSteps() async {
    SharedPreferences compSteps = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    StepTrackerModel().initialize();
    showGreetingNotification();
    // StepTrackerCubit().initialize();
    // StepTrackerCubit().reset();
  }

  Future<void> showGreetingNotification() async {
    int hour = DateTime.now().hour;
    String greeting;

    if (hour >= 5 && hour < 12) {
      greeting = "Good Morning! ☀️ $userName";
    } else if (hour >= 12 && hour < 18) {
      greeting = "Good Afternoon! 🌤️ $userName";
    } else {
      greeting = "Good Evening! 🌙 $userName";
    }
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'greeting_channel',
      'Greeting Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      greeting,
      "Let's get those steps in!",
      platformChannelSpecifics,
    );
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
                title: BlocBuilder<StepTrackerCubit, int>(
                    builder: (context, steps) {
                  if (isExpanded) {
                    return SizedBox(
                      height: .1,
                    );
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 40,
                          height: 40,
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
                        Text('$steps steps')
                      ],
                    );
                  }
                }),
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
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(profilePhoto),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: 315,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 18),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StepsActions()));
                                },
                                child: Icon(
                                  Icons.menu,
                                  size: 35,
                                ),
                              ),
                            )
                          ],
                        ),
                        BlocBuilder<StepTrackerCubit, int>(
                          builder: (context, steps) {
                            log("Homescreen steps: $steps");
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
                        // BlocListener<StepTrackerCubit, int>(
                        //   listener: (context, state),),
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
    ));
  }

  Widget leaderBoard() {
    var hasData = true;

    List<TableRow> rows = [];
    for (int i = 1; i < 101; i++) {
      rows.add(TableRow(children: [
        Text(i.toString())
      ]));
    }

    if (hasData) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 100,
        itemBuilder: (context, index){
          return UserInfoCard(profilePicture: UsersSteps().profilepicture, userName: , steps: null,)
        },);
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Table(
                children: rows,
              ),
            )
          ]);
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
            ),
            CircularProgressIndicator(),
          ]);
    }
  }
}
