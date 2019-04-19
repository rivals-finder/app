import 'package:flutter/material.dart';
import './bloc/bloc.dart';

class News extends StatefulWidget {
  News({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('News')),
    );
  }

}