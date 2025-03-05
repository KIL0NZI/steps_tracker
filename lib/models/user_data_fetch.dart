import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:steps_tracker/state/steps_tracker_cubit.dart';

class UserDataFetch {
  final _googleUSerBox = Hive.box('googleUSerBox');
  final _userBox = Hive.box('userBox');
  final StepTrackerCubit stepTrackerCubit = StepTrackerCubit();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> users = [];

  Future<void> getUSerData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('usersteps').get();
      users = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      log(users.toString());
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> postUserData(int event) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _firestore.collection('usersteps').doc(user.uid).set({
          'username': user.displayName ?? "Unknown",
          'profilephoto': user.photoURL ?? "",
          'steps': event, // Example: Initial steps count
          'timestamp': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)); // Merge to avoid overwriting all data

        log("✅ User data posted successfully!");
      } else {
        log("❌ No user is signed in!");
      }
    } catch (e) {
      log("❌ Error posting data: $e");
    }
  }
}
