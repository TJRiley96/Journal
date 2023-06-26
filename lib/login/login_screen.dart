// File: login_screen.dart
//
//
//
//
// Author: T.J. Riley           Date Created: 06/21/2023
// Copyright: Copyright (c) 2022 Thomas Riley.
// Maintainer: T.J. Riley
// Status: Development
//

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hash/hash.dart';
import 'package:journal/auth/auth_fb.dart';
import 'package:journal/com/hash_pwd.dart';
import 'package:journal/globals.dart' as globals;
import '../color_palette.dart';

class LoginScreen extends StatefulWidget {
  /// Login screen for enter main screen.
  /// Must go through this screen to in order to use app.
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Widget buildForgotPassBtn() {
  return Container(
    alignment: Alignment.centerRight,
    child: TextButton(
      // TODO: Add forgot password functionality
      onPressed: () => print("Forgot Password Pressed"),
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget buildSkipBtn(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 25),
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(15),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: Text(
        "Skip",
        style: TextStyle(
            color: textMain, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/post/create');
      },
    ),
  );
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRememberMe = false;
  String userEmail = '';
  int userPass = 0;

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Email",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              userEmail = value;
            },
            style: const TextStyle(
              color: Colors.black87,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email,
                  color: iconMain,
                ),
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Password",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextField(
            obscuringCharacter: '#',
            obscureText: true,
            onChanged: (value) {
              userPass = hashPassword(value);
            },
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(
              color: Colors.black87,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.password,
                  color: iconMain,
                ),
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildRememberCheck() {
    return Container(
      height: 20,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: isRememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  isRememberMe = value!;
                });
              },
            ),
          ),
          const Text(
            "Remember Me",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(15),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Text(
          "Login",
          style: TextStyle(
              color: textMain, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // TODO: Add login functionality
        onPressed: () async {
          log("Login Pressed\nEmail: $userEmail\nPassword: $userPass");
          try {
            final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: userEmail,
                password: userPass.toString()
            );
            log("$credential");
            userCredential = credential;
            globals.user = credential;
            log('User Credentials Log - ${globals.user.credential}');
            log('User user Log - ${globals.user.user}');
            log('User Additional User Info Log - ${globals.user.additionalUserInfo}');
            Navigator.of(context).pushNamed('/post/create');
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              log('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              log('Wrong password provided for that user.');
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: backgroundMain),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 120,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    buildEmail(),
                    const SizedBox(
                      height: 20,
                    ),
                    buildPassword(),
                    buildForgotPassBtn(),
                    buildRememberCheck(),
                    buildLoginBtn(),
                    buildSkipBtn(context)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
