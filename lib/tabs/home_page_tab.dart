import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:steps_tracker/Themes/colors.dart';
import 'package:steps_tracker/models/bottom_nav_bar.dart';
import 'package:steps_tracker/models/progress_bar.dart';
import 'package:steps_tracker/models/step_tracker_model.dart';
import 'package:steps_tracker/tabs/leaderboard_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _selectedIndex = 0;

  // // StepCount stepCount = StepCount();

  // void _onItemSelected(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   if (index == 0) {
  //     MaterialPageRoute(builder: (BuildContext context) => const LeaderBoard());
  //   }
  //   if (index == 1) {
  //     MaterialPageRoute(builder: (BuildContext context) => const LeaderBoard());
  //   }
  //   if (index == 2) {
  //     MaterialPageRoute(builder: (BuildContext context) => const LeaderBoard());
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StepTrackerModel().initialize();
  }

  bool _isExpanded = true;

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
                _isExpanded = appBarHeight > 150;

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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person,
                                      size: 30, color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                 Text(
                                  'Good Evening, John',
                                  style: GoogleFonts.darkerGrotesque(
                                    fontSize: 24,
                                  ),
                                ),
                              ]),
                          Column(
                            children: [
                              SizedBox(
                                width: 180,
                                height: 180,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 180,
                                      height: 180,
                                      child: CustomCircularProgressIndicator(
                                        progress: 0.75, // 75% progress
                                        strokeWidth: 25.0,
                                        innerRadius: 0.0,
                                        progressColor: Colors.blue,
                                        backgroundColor: Colors.grey.shade200,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                         StreamBuilder<StepCount>(
                                            stream: StepTrackerModel().stepCountStream,
                                            builder: (context, snapshot) {
                                              return Text(
                                                '${snapshot.data?.steps ?? 0}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }),
                                        const Text(
                                          'steps',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Daily Goal: 10,000 steps',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
            color: Colors.white, // Optional: adds background color
            child: GridView.count(
              physics:
                  const NeverScrollableScrollPhysics(), // Prevents grid scrolling
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                    'Calories', '350 kcal', Icons.local_fire_department),
                _buildStatCard('Distance', '2.5 km', Icons.directions_walk),
                _buildStatCard('Time', '35 min', Icons.timer),
                _buildStatCard('Heart Rate', '75 bpm', Icons.favorite),
              ],
            ),
          ),
          // Empty body since we're using SliverFillRemaining
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
