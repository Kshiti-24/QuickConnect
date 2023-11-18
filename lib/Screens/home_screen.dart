import 'dart:developer';

import 'package:chatterbox/Models/chat_user.dart';
import 'package:chatterbox/Network/APIs.dart';
import 'package:chatterbox/Screens/login_screen.dart';
import 'package:chatterbox/Screens/profile_screen.dart';
import 'package:chatterbox/Widgets/chat_card.dart';
import 'package:chatterbox/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelf();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_isSearching) {
          setState(() {
            _isSearching = !_isSearching;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(CupertinoIcons.home),
          title: _isSearching
              ? TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Name, Email, ..."),
                  autofocus: true,
                  style: TextStyle(fontSize: 16, letterSpacing: 0.5),
                  onChanged: (val) {
                    _searchList.clear();
                    for (var i in list) {
                      if ((i.name.toLowerCase().contains(val.toLowerCase())) ||
                          (i.name.toLowerCase().contains(val.toLowerCase()))) {
                        _searchList.add(i);
                      }
                      setState(() {
                        _searchList;
                      });
                    }
                  },
                )
              : Text("QuickConnect"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(_isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : CupertinoIcons.search),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              user: APIs.selfInfo,
                            )));
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                // if some or all data is loaded
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : list.length,
                        padding: EdgeInsets.only(top: size.height * 0.01),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatCard(
                            user:
                                _isSearching ? _searchList[index] : list[index],
                          );
                          // return Text("Name : ${list[index]}");
                        });
                  } else {
                    return Center(
                      child: Text(
                        "No Connections Found",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            log("\nUser has signed out");
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          },
        ),
      ),
    );
  }
}
