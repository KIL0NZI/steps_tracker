import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:steps_tracker/models/auth.dart';
import 'package:steps_tracker/screens/landing_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void functionOne(){
    MaterialPageRoute(builder: (BuildContext context) => LandinPage());

  }

  Widget _title() {
    return const Text('Firebase auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
        onPressed: () {
          signOut;
          
        },
        child: Text('Signout'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [_userUid(), _signOutButton()],
        ),
      ),
    );
  }
}
