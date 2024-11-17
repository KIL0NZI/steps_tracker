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

  void functionOne() {
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

  Widget _signInButton() {
    return Placeholder();
    // ElevatedButton(
    //   onPressed: signInWithGoogle, // Direct reference to the function
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Image.asset(
    //         'assets/google_logo.png', // Make sure to add this image to your assets
    //         height: 24.0,
    //       ),
    //       const SizedBox(width: 12.0),
    //       const Text('Sign in with Google'),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _userUid(),
              const SizedBox(height: 16.0),
              user == null ? _signInButton() : _signOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
