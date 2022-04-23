//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isits/models/user.dart';
import 'package:provider/provider.dart';
import 'package:isits/screens/seat_info_screen.dart';

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
  final _describeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference seats =
      FirebaseFirestore.instance.collection("locations");
  late String valueFloorText;
  late String valueChatText;
  late String valueNumberText;
  late String valueDescribeText;
  late String floorText;
  late String chatText;
  late String numberText;
  late String describeText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      appBar: AppBar(
        //backgroundColor: Colors.black.withOpacity(0.1),
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
                color: Colors.indigo.shade900,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('seats')
                      .where('lid', isEqualTo: widget.locationId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return Center(
                          child: Text(
                            "No people offering seats",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SeatInfoScreen(
                                          locationId: widget.locationId,
                                          seatId: snapshot.data.docs[index]
                                              .id, //TODO: fix this
                                        ),
                                      ));
                                },
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
                TextField(
                  onChanged: (value4) {
                    setState(
                      () {
                        valueDescribeText = value4;
                      },
                    );
                  },
                  controller: _describeController,
                  decoration: InputDecoration(
                      hintText: "Give a description of where it is"),
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
                  describeText = valueDescribeText;
                  await _db
                      .collection("seats")
                      .doc(_auth.currentUser?.uid)
                      .set({
                    "floor": floorText,
                    "Time": DateTime.now(),
                    "amount": numberText,
                    "chat": chatText,
                    "description": describeText,
                    "lid": widget.locationId,
                    "sid": _auth.currentUser?.uid
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
