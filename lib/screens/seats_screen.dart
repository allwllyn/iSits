//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isits/models/user.dart';

class SeatScreen extends StatelessWidget {
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
              receiverName,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
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
                      .doc(locationId)
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
}
