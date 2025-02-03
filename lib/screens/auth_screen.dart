import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:steps_tracker/models/auth.dart';
import 'package:steps_tracker/screens/new_user_screen.dart';
import 'package:steps_tracker/tabs/home_page_tab.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final Auth _auth = Auth();
  late TextEditingController _email = TextEditingController();
  late final TextEditingController _passWord = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _passWord.dispose();
    super.dispose();
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
                'Welcome Back :)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
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
                    return 'Please enter your password';
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
                  await login(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  backgroundColor: Colors.amberAccent,
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
                child: Text('Sign In'),
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
                            context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      }
                    } catch (e) {
                      log('haki ya nani ${e.toString()}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
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
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => NewUserScreen()));
                      log('I have been touched helppp!');
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blueGrey,
                          decorationThickness: 2),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await Auth()
            .signInWithEmailAndPassword(email: _email.text.trim(), password: _passWord.text.trim());
        log('${_email.text} ${_passWord.text}');

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hello ${_email.text}')));
        // Handle login logic
      } catch (e) {
        log('Error signing in: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Incorrect Email or Password')));
      }
    }
  }
}
