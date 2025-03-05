import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _googleUserBox = Hive.box('googleUserBox');

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        throw 'Invalid email format.';
      }
      throw e.message ?? 'An unknown error occurred.';
    }
  }

  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return false;
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        log('email already in use');
      }
      return true;
    } catch (e) {
      log(e.toString());
      return true;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> signInWithGoogle() async {
    bool result = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore.collection('users').doc(user.uid).set({
            'username': user.displayName,
            'uid': user.uid,
            'profilephoto': user.photoURL
          });
          log('User saved in Hive: ${user.displayName}, ${user.photoURL}');

          // if (!_googleUserBox.containsKey(1) &&
          //     !_googleUserBox.containsKey(2)) {
          await _googleUserBox.put('username', user.displayName ?? 'no Name');
          await _googleUserBox.put(
              'profilephoto', user.photoURL ?? 'no picture');
          await _googleUserBox.put('uid', user.uid);
          log('User saved in Hive: ${_googleUserBox.get('username')}, ${_googleUserBox.get('profilephoto')}');
          // }
        }
      } else {
        log('aha gotcha');
      }
      result = true;
      return result;
    } catch (e) {
      log(e.toString());
      return result;
    }
  }
}
