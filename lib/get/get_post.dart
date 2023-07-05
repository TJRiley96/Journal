import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetFirePost extends StatefulWidget {
  const GetFirePost({super.key});

  @override
  State<GetFirePost> createState() => _GetFirePostState();
}

class _GetFirePostState extends State<GetFirePost> {
  String entry = "No Data";
  final userID = FirebaseAuth.instance.currentUser?.uid;
  bool dataCheck = false;

  @override
  Widget build(BuildContext context) {
    print(userID);
    if(entry == "No Data" && !dataCheck){
      retrieve();
    }

    return Scaffold(
      body: Text(entry),
    );
  }

  void retrieve() {
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .collection('posts')
          .doc('20230625')
          .get()
          .then((value) {
        if (value.exists) {
          print("Data Exists!");
          setState(() {
            print("Fetching entry...");
            entry = value.data()?['entry'];
            print(entry);
          });
        } else {
          print(value.exists);
          print("Data is unavailable.");
        }
        dataCheck = true;
      });
    } catch (e){
      print(e);
    }
  }
}
