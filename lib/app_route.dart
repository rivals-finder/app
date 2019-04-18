import 'package:flutter/material.dart';
import './home.dart';
import './auth.dart';
import './bloc/bloc.dart';

class AppRoute extends StatefulWidget {
  @override
  _AppRouteState createState() => _AppRouteState();
}

class _AppRouteState extends State<AppRoute> {
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
