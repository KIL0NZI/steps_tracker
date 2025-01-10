import 'package:flutter/foundation.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:steps_tracker/models/auth.dart';
import 'package:steps_tracker/screens/user_information_screen.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  late TextEditingController _email = TextEditingController();
  late final TextEditingController _passWord = TextEditingController();

  bool _isObscured = true;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
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
                  await Auth().createUserWithEmailAndPassword(
                      email: _email.text.trim(),
                      password: _passWord.text.trim());
                  log('${_email.text} ${_passWord.text}');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UserInformationScreen()));

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Hello ${_email.text}')));
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
          ],
        ),
      ),
    );
  }
}
