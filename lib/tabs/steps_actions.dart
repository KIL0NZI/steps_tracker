import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steps_tracker/models/user_data_fetch.dart';
import 'package:steps_tracker/state/steps_tracker_cubit.dart';

class StepsActions extends StatelessWidget {
  StepsActions({
    super.key,
  });

  final UserDataFetch userDataFetch = UserDataFetch();
  // final String username;
  // final String profilePhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // BlocBuilder<StepTrackerCubit, int>(builder: (context, steps) {
            // return
            ElevatedButton(
                onPressed: () {
                  // userDataFetch.postUserData(event);
                },
                child: Text('upload data')),
            // }),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  userDataFetch.getUSerData();
                },
                child: Text('fetch data'))
          ],
        ),
      ),
    );
  }
}
