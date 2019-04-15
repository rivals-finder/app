import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './home.dart';
import './auth.dart';

void main() => runApp(RivalsFinder());

class RivalsFinder extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<RivalsFinder> {
  bool loading = true;
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  _getCurrentUser() async {
    mCurrentUser = await _auth.currentUser();
    setState(() {
      loading = false;
      mCurrentUser = mCurrentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: loading
            ? Scaffold(
                appBar: AppBar(
                  title: Text('Добро пожаловать!'),
                ),
                body: Container(
                  child: Text('Loading...'),
                ))
            : (mCurrentUser != null ? Home(user: mCurrentUser) : Auth()));
  }
}
