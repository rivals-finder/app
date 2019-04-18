import 'package:flutter/material.dart';
import './home.dart';
import './bloc/bloc.dart';

class Auth extends StatefulWidget {
  Auth({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  FireBloc fireBloc;

  void initState() {
    super.initState();
    fireBloc = BlocProvider.of(context);
  }

  void _loginPressed() async {
    final FirebaseUser user =
        await fireBloc.logIn(_emailFilter.text, _passwordFilter.text);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Добро пожаловать!'),
            automaticallyImplyLeading: false),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  controller: _emailFilter,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ),
              Container(
                child: TextField(
                  controller: _passwordFilter,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ),
              RaisedButton(
                child: new Text('Login'),
                onPressed: _loginPressed,
              ),
            ],
          ),
        ));
  }
}
