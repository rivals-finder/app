import 'package:flutter/material.dart';
import './home.dart';
import './auth.dart';
import './bloc/bloc.dart';

void main() => runApp(RivalsFinder());

class RivalsFinder extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<RivalsFinder> {
  bool loading = true;
  FirebaseUser mCurrentUser;
  FireBloc fireBloc;

  @override
  void initState() {
    super.initState();
    fireBloc = BlocProvider.of(context);
    _getCurrentUser();
  }

  _getCurrentUser() async {
    mCurrentUser = await fireBloc.getCurrentUser();
    setState(() {
      loading = false;
      mCurrentUser = mCurrentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProvidersWrapper(
        child: MaterialApp(
            theme: ThemeData(primarySwatch: Colors.blue),
            home: loading
                ? Scaffold(
                    appBar: AppBar(
                      title: Text('Добро пожаловать!'),
                    ),
                    body: Container(
                      child: Text('Loading...'),
                    ))
                : (mCurrentUser != null ? Home(user: mCurrentUser) : Auth())));
  }
}
