import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:steps_tracker/models/auth.dart';
import 'package:steps_tracker/screens/auth_screen.dart';
import 'package:steps_tracker/tabs/home_page_tab.dart';
import 'package:steps_tracker/tabs/target-steps.dart';

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
  final _myBox = Hive.box('myBox');

  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;

  // Future<void> saveUserToFirestore(
  //     String uid, String username, String email) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('users').doc(uid).set({
  //       'username': username,
  //       'email': email,
  //       'createdAt': FieldValue.serverTimestamp()
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('User saved successfully!')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: ${e.toString()}')),
  //     );
  //     log(e.toString());
  //   }
  // }

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello There :)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                  controller: _username,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'username',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (value.isNotEmpty && !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passWord,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
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
                  if (_formKey.currentState!.validate()) {
                    try {
                      bool isNew = await _auth.createUserWithEmailAndPassword(
                          email: _email.text.trim(),
                          password: _passWord.text.trim());
                      log('${_email.text} ${_passWord.text}');
                      if (isNew) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(_auth.currentUser?.uid)
                            .set({
                          'username': _username.text.trim(),
                          'email': _email.text.trim(),
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        if (_myBox.isEmpty) {
                          await _myBox.put(1, _username.text.trim());
                        } else {
                          var userName = _myBox.get(1);
                          log('$userName has entered the chat');
                        }
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TargetSteps()));

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Hello ${_username.text}')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occured, Please try again')));
                      }
                      // Handle login logic
                    } on FirebaseException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Email already in use. Try logging in.')),
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.message}')),
                      );
                    } catch (e) {
                      log('Error signing in: $e');
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Email already in use')));
                    }
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
              ElevatedButton(
                  onPressed: () async {
                    try {
                      bool result = await _auth.signInWithGoogle();
                      if (result) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TargetSteps()));
                      }
                    } catch (e) {
                      log('haki ya nani ${e.toString()}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    backgroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50), // Full width button
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'http://pngimg.com/uploads/google/google_PNG19635.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                      Text('Continue with Google')
                    ],
                  )),
              SizedBox(
                height: 8,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthScreen()));
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
      ),
    );
  }
}
