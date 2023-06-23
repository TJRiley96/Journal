

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthMinder{
  StreamSubscription<User?> login(){
    return FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
}