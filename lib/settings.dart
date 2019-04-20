import 'package:flutter/material.dart';
import './bloc/bloc.dart';
import './auth.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final textName = TextEditingController();
  final textPassword = TextEditingController();
  FireBloc fireBloc;
  void initState() {
    super.initState();
    fireBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    textName.dispose();
    textPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (textName.text != null || textPassword.text != null) {
                fireBloc.changeCurrentUserInfo(
                    textName.text, textPassword.text);
              }
              Navigator.pop(context);
            },
          ),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await fireBloc.logOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Auth()),
                );
              }),
        ],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Введите новое имя пользователя',
            ),
            controller: textName,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Введите новый пароль',
            ),
            obscureText: true,
            controller: textPassword,
          )
        ],
      )),
    );
  }
}
