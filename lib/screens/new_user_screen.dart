import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:steps_tracker/models/auth.dart';
import 'package:steps_tracker/screens/auth_screen.dart';
import 'package:steps_tracker/tabs/home_page_tab.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  late TextEditingController _email = TextEditingController();
  late final TextEditingController _username = TextEditingController();
  late final TextEditingController _passWord = TextEditingController();
  final Auth _auth = Auth();

  bool _isObscured = true;

  Future<void> saveUserToFirestore(
      String uid, String username, String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp()
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      log(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _passWord.dispose();
    _username.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello There :)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
                controller: _username,
                decoration: InputDecoration(
                  labelText: 'username',
                  border: OutlineInputBorder(),
                )),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _email,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passWord,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                      ))),
              obscureText: _isObscured,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _auth.createUserWithEmailAndPassword(
                      username: _username.text.trim(),
                      email: _email.text.trim(),
                      password: _passWord.text.trim());
                  log('${_email.text} ${_passWord.text}');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen()));

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Hello ${_username.text}')));
                  // Handle login logic
                } catch (e) {
                  log('Error signing in: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email already in use')));
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                backgroundColor: Colors.amberAccent,
                minimumSize: Size(double.infinity, 50), // Full width button
              ),
              child: Text('Sign Up'),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AuthScreen()));
                    log('I have been touched helppp!');
                  },
                  child: Text(
                    'Log in instead',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blueGrey,
                        decorationThickness: 2),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
