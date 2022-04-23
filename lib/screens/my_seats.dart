//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isits/models/user.dart';
import 'package:provider/provider.dart';
import 'package:isits/screens/seat_info_screen.dart';

class MySeatsScreen extends StatefulWidget {
  //final UserModel currentUser;
  final String userId;
  //final String receiverName;
  //final String receiverImage;

  MySeatsScreen({
    //required this.currentUser,
    required this.userId,
    //required this.receiverName,
    //required this.receiverImage,
  });

  @override
  State<MySeatsScreen> createState() => _MySeatsScreenState();
}

class _MySeatsScreenState extends State<MySeatsScreen> {
  final _floorController = TextEditingController();
  final _numberController = TextEditingController();
  final _chatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference seats = FirebaseFirestore.instance.collection("seats");
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
        //backgroundColor: Colors.black.withOpacity(0.1),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              //child: Image.network(
              //receiverImage,
              //height: 35,
              //),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'My Seats',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
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
                  stream: seats
                      .where('sid', isEqualTo: _auth.currentUser?.uid)
                      //.doc(_auth.currentUser?.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length > 0) {
                        return ListView.builder(
                            itemCount: 1,
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
                                    editSeat();
                                  },
                                ),
                              );
                            });
                      }
                    }
                    return const Center(
                        child: Text(
                      "You are not currently offering a seat",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ));
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void editSeat() async {
    //await _db.collection("posts").add({"message": "Random stuff can go here"});
    _displayTextInputDialog(context);
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete?'),
            content: Column(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete?',
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
                child: Text('Delete Seat'),
                onPressed: () async {
                  await _db
                      .collection("seats")
                      //.doc('Library')
                      //.collection("seats")
                      .doc(_auth.currentUser?.uid)
                      .delete();

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
