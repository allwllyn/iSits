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
                              Image(
                                image: NetworkImage(
                                  //'https://picsum.photos/200')
                                  snapshot.data['image'],
                                ),
                              )
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
}
