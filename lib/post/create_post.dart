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


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../color_palette.dart';

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
  var _today;
  var _dateOutput;


  @override
  Widget build(BuildContext context) {
    _today = DateFormat.yMMMMd().format(_date);
    _dateOutput = DateFormat("yMMd").format(_date);
    return _buildContent(context);
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
              maxLines: 500,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                entry = value;
              },
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

    if(picked != null && picked != _date) {
      print('Date selected: ${_date.toString()}');
      print(_today);
      print(_dateOutput);
      setState((){
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
                                    onPressed: () => print(entry),
                                    child: const Text("Post"))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ElevatedButton( onPressed: ()=> _selectDate(context), child: Text("$_today"),)
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
