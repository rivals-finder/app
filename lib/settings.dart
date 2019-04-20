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
  var _theme = ['Светлая', 'Тёмная'];
  var _currentItemSelectedTheme = 'Светлая';

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Введите новое имя пользователя',
              ),
              controller: textName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Введите новый пароль',
              ),
              obscureText: true,
              controller: textPassword,
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: DropdownButton<String>(
          //     isExpanded: true,
          //     hint: Text('Светлая'),
          //     items: _theme.map((String dropDownSringItem) {
          //       return DropdownMenuItem<String>(
          //         value: dropDownSringItem,
          //         child: Text(dropDownSringItem),
          //       );
          //     }).toList(),
          //     onChanged: (String newValueSelected) {
          //       setState(() {
          //         this._currentItemSelectedTheme = newValueSelected;
          //       });
          //     },
          //     style: new TextStyle(
          //       color: Colors.black,
          //       fontSize: 16.0,
          //     ),
          //     value: _currentItemSelectedTheme,
          //   ),
          // ),

        ],
      )),
    );
  }
}
