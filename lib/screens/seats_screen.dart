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
  final _postController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference seats =
      FirebaseFirestore.instance.collection("locations");
  late String valueText;
  late String seatText;

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
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _postController,
              decoration: InputDecoration(hintText: "Message"),
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
                  seatText = valueText;
                  await _db
                      .collection("locations")
                      .doc(widget.locationId)
                      .collection("seats")
                      .add({"message": seatText, "Time": DateTime.now()});
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
