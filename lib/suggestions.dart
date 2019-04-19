import 'package:flutter/material.dart';
import './bloc/bloc.dart';

class Suggestions extends StatefulWidget {
  Suggestions({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(child: Text('Suggestions')),
    );
  }

}