//import 'dart:html';

import 'package:isits/models/user.dart';
import 'package:isits/screens/my_seats.dart';
import 'package:isits/screens/seats_screen.dart';
import 'package:isits/services/auth_bloc.dart';
import 'package:isits/screens/signin.dart';
import 'package:provider/provider.dart';
import 'package:isits/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  UserModel user;
  HomePage(this.user);

  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  final _postController = TextEditingController();
  late String valueText;
  late String postText;
  List<Map> searchResult = [];

  void loadChats() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("no recent chats")));
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['email'] != widget.user.email) {
          searchResult.add(user.data());
        }
      });
    });
  }

  @override
  void initState() {
    //to call function as soo as page loads, do here
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SignInPage()));
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.chair_sharp),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        MySeatsScreen(userId: _auth.currentUser!.uid)),
              );
            },
          ),
          title: Text('Locations'),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {
                authBloc.logout();
              },
            )
          ]),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('locations')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length < 1) {
                    return Center(
                      child: Text("didnt load properly"),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height /
                                  snapshot.data.docs.length -
                              30,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(3, 4, 3, 0),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(15),
                              child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data.docs[index]['image']),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.indigo.shade900
                                                .withOpacity(0.9),
                                            BlendMode.modulate),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        snapshot.data.docs[index]['lid'],
                                        style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SeatScreen(
                                            locationId: snapshot
                                                .data.docs[index]['lid'],
                                            receiverName: snapshot
                                                .data.docs[index]['lid'],
                                          ),
                                        ));
                                  }),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: Text("something wrong"),
                  );
                }
              })
        ],
      ),
    );
  }
}
