//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isits/models/user.dart';
import 'package:provider/provider.dart';

class SeatScreen extends StatefulWidget {
  //final UserModel currentUser;
  final String locationId;
  final String receiverName;
  //final String receiverImage;

  SeatScreen({
    //required this.currentUser,
    required this.locationId,
    required this.receiverName,
    //required this.receiverImage,
  });

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  final _floorController = TextEditingController();
  final _numberController = TextEditingController();
  final _chatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference seats =
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
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              //child: Image.network(
              //receiverImage,
              // height: 35,
              //),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              widget.receiverName,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          addSeat();
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('locations')
                      .doc(widget.locationId)
                      .collection('seats')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return Center(
                          child: Text("No people offering seats"),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text("Floor: " +
                                    snapshot.data.docs[index]['floor'] +
                                    " Chat: " +
                                    snapshot.data.docs[index]['chat']),
                                subtitle: Text("Open Seats: " +
                                    snapshot.data.docs[index]['amount']),
                                tileColor: Colors.blue,
                              ),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void addSeat() async {
    //await _db.collection("posts").add({"message": "Random stuff can go here"});
    _displayTextInputDialog(context);
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Seat'),
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
                child: Text('Add Seat'),
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
