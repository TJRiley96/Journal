// File: create_post.dart
//
// Description:
//
//
// Author: T.J. Riley           Date Created: 06/21/2023
// Copyright: Copyright (c) 2022 Thomas Riley.
// Maintainer: T.J. Riley
// Status: Development
//

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:journal/auth/auth_fb.dart';
import 'package:journal/com/entry_object.dart';
import 'dart:io';
import '../color_palette.dart';
import 'package:journal/globals.dart' as globals;

class CreatePostScreenTest extends StatefulWidget {
  /// Screen to create journal entry for posting.
  /// User enters entry and click uploads to firebase database.
  const CreatePostScreenTest({super.key});

  @override
  State<CreatePostScreenTest> createState() => _CreatePostScreenStateTest();
}

class _CreatePostScreenStateTest extends State<CreatePostScreenTest> {
  String entry = "";
  DateTime _date = DateTime.now();
  var _today;
  var _dateOutput;
  final collectionRef = FirebaseFirestore.instance
      .collection('User')
      .doc(globals.user.user?.uid)
      .collection('posts');
  final textController = TextEditingController();
  late Entry userEntry = Entry(
      dateID: _dateOutput,
      dateLong: _today,
      entry: entry,
      dateModified: DateTime.now());

  Future<String> getEntryTest() async {
    var getEnt = await collectionRef.doc(_dateOutput);
    log('$getEnt');
    var data =getEnt.data();
    var e = data?['entry'];
    return e;

  }
  void updateText() async {
    if (await checkIfDocExists(_dateOutput)) {
      textController.text = await getEntryTest();
      log('$textController');
    }
  }

  @override
  void initState() {
    super.initState();

    updateText();
    // Start listening to changes.
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _today = DateFormat.yMMMMd().format(_date);
    _dateOutput = DateFormat("yMMd").format(_date);
    entry = textController.text;
    return _buildContent(context);
  }

  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef =
      FirebaseFirestore.instance.collection('User').doc(globals.user.user?.uid).collection('posts');

      var doc = await collectionRef.doc(docId).get();
      log('$doc');
      log('${doc.exists}');
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  Future post() async {
    final send = FirebaseFirestore.instance
        .collection('Users')
        .doc(globals.user.user?.uid)
        .collection('posts')
        .doc(userEntry.dateID);

    await collectionRef.doc(userEntry.dateID).set(userEntry.toJson());
  }

  Future<bool> changeValue() async {
    bool checked = false;
    var doc = await checkIfDocExists(_dateOutput);
    checked = doc;
    return checked;
  }

  Widget buildPostWriter() {
    return FractionallySizedBox(
      widthFactor: 0.90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Post",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 500,
            alignment: Alignment.topLeft,
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
            child: TextField(
              controller: textController,
              maxLines: 500,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                color: Colors.black87,
              ),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14, left: 10, right: 10),
                  hintText: "Write a post...",
                  hintStyle: TextStyle(color: Colors.black38)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2012),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _date) {
      print('Date selected: ${_date.toString()}');
      print(_today);
      print(_dateOutput);
      setState(() {
        _date = picked;
      });
    }
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      body: FractionallySizedBox(
        heightFactor: 1,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundMain.last,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                      print(entry);
                                      post();
                                    },
                                    child: const Text("Post"))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text("$_today"),
                                )
                              ],
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Close")),
                                ])
                            // TextButton(
                            //   child: const Text(
                            //     'Close',
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //       decoration: TextDecoration.underline,
                            //     ),
                            //   ),
                            //   onPressed: () => Navigator.pop(context),
                            // ),
                          ]),
                      const SizedBox(
                        height: 5,
                      ),
                      buildPostWriter()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
