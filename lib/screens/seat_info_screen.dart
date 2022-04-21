//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isits/models/user.dart';
import 'package:provider/provider.dart';

class SeatInfoScreen extends StatefulWidget {
  final String seatId;
  final String locationId;
  //comment for testing
  //checking

  SeatInfoScreen({
    required this.seatId,
    required this.locationId,
  });

  @override
  State<SeatInfoScreen> createState() => _SeatInfoScreenState();
}

class _SeatInfoScreenState extends State<SeatInfoScreen> {
  final _floorController = TextEditingController();
  final _numberController = TextEditingController();
  final _chatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference location =
      FirebaseFirestore.instance.collection("locations");
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
              widget.locationId + " Seat",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            /*child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.shade500,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),*/
            child: StreamBuilder(
                stream: location
                    .doc(widget.locationId)
                    .collection('seats')
                    .doc(widget.seatId)
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
                                "Description: " + snapshot.data['description'],
                                //textAlign: TextAlign.left,
                                style: const TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                  //fontFamily:
                                ),
                              ),
                              Text(
                                "\n\nOpen to chat: " + snapshot.data['chat'],
                                //textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  onPrimary: Colors.white,
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                onPressed: () {},
                                child: Text('Message'),
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
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Send'),
                onPressed: () async {
                  floorText = valueFloorText;
                  numberText = valueNumberText;
                  chatText = valueChatText;
                  await _db
                      .collection("locations")
                      .doc(widget.locationId)
                      .collection("seats")
                      .add({
                    "floor": floorText,
                    "Time": DateTime.now(),
                    "amount": numberText,
                    "chat": chatText
                  });
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
