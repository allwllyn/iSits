//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isits/models/user.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({
    required this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _floorController = TextEditingController();
  final _numberController = TextEditingController();
  final _chatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  late String valueFloorText;
  late String valueChatText;
  late String valueNumberText;
  late String floorText;
  late String chatText;
  late String numberText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Profile',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: users
                    //.doc(widget.locationId)
                    //.collection('seats')
                    .doc(widget.userId)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Card(
                        margin: EdgeInsets.all(20),
                        elevation: 10,
                        color: Colors.indigo.shade500,
                        child: (Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Name: " + snapshot.data['name'],
                                //textAlign: TextAlign.left,
                                style: const TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                  //fontFamily:
                                ),
                              ),
                              Text(
                                "\n\nEmail: " + snapshot.data['email'],
                                //textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )));
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          //),
        ],
      ),
    );
  }

  void message() async {
    _displayTextInputDialog(context);
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Message user'),
            content: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    setState(
                      () {
                        valueFloorText = value;
                      },
                    );
                  },
                  controller: _floorController,
                  decoration: InputDecoration(hintText: "Floor"),
                ),
                TextField(
                  onChanged: (value2) {
                    setState(
                      () {
                        valueChatText = value2;
                      },
                    );
                  },
                  controller: _chatController,
                  decoration: InputDecoration(hintText: "Open to Chat?"),
                ),
                TextField(
                  onChanged: (value3) {
                    setState(
                      () {
                        valueNumberText = value3;
                      },
                    );
                  },
                  controller: _numberController,
                  decoration: InputDecoration(hintText: "How many seats open?"),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
