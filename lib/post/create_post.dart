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

class CreatePostScreen extends StatefulWidget {
  /// Screen to create journal entry for posting.
  /// User enters entry and click uploads to firebase database.
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String entry = "";
  DateTime _date = DateTime.now();
  bool dataCheck = false;
  var _today;
  String _dateOutput = '';
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final textController = TextEditingController();

  //
  // Future<String> getEntryTest() async {
  //   log('=============Beginning=============');
  //   if(await checkIfDocExists(_dateOutput)){
  //   var getEnt = await collectionRef.doc(_dateOutput).get();
  //   log('GetEntryTest: $getEnt');
  //   var data =getEnt.data();
  //   var e = data?['entry'];
  //   log('Entry Data: $e');
  //   return e;
  //   }
  //   return '';
  // }
  void _fetchUserData() {
    print("=============User DATA=============\n");
    try {
      print("Loading data...\n");
      print("Searching for: $_dateOutput");
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .collection('posts')
          .doc(_dateOutput)
          .get()
          .then((value) {
        if (value.exists) {
          print("Data Exists!");
          setState(() {
            print("Fetching entry...");
            entry = value.data()?['entry'];
            print(entry);
            textController.text = entry;
          });
        } else {
          print(value.exists);
          print("No Entries!");
          entry = '';
          textController.text = entry;
        }
        dataCheck = true;
      });
    } catch (e) {
      print(e);
    }
  }

  // void updateText() async {
  //   if (await checkIfDocExists(_dateOutput)) {
  //     textController.text = await getEntryTest();
  //     log('$textController');
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateDate();
    if (!dataCheck) {
      _fetchUserData();
    }
    entry = textController.text;
    return _buildContent(context);
  }

  Future post() async {
    entry = textController.text;
    Entry userEntry = Entry(
        dateID: _dateOutput,
        dateLong: _today,
        entry: entry,
        dateModified: DateTime.now());

    final send = FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('posts')
        .doc(userEntry.dateID);

    await send.set(userEntry.toJson());
  }

  // Future<bool> changeValue() async {
  //   bool checked = false;
  //   var doc = await checkIfDocExists(_dateOutput);
  //   checked = doc;
  //   return checked;
  // }

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
      setState(() {
        _date = picked;
        updateDate();
        dataCheck = false;
      });
    }
  }

  void updateDate() {
    _today = DateFormat.yMMMMd().format(_date);
    _dateOutput = DateFormat("yMMdd").format(_date);
    log('================DATE================\n');
    log('Date Picked: $_date\nDate Format: $_today\nDate File Output: $_dateOutput\n');
    log('================DATE================');
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
