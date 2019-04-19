import 'package:flutter/material.dart';
import './bloc/bloc.dart';

class Creator extends StatefulWidget {
  const Creator({Key key}) : super(key: key);

  @override
  CreatorState createState() => CreatorState();
}

class CreatorState extends State<Creator> {
  FireBloc fireBloc;

  var _type = ['Теннис', 'Бильярд', 'Кикер', 'Дартс'];
  var _actualTime = ['1 час', '2 часа', '1 день', '1 неделя'];
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    fireBloc = BlocProvider.of(context);
  }

  var _currentItemSelectedType;
  var _currentItemSelectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Создание игры"),
      ),
      body: new Center(
          child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DropdownButton<String>(
            isExpanded: true,
            hint: Text('Выбрать игру'),
            items: _type.map((String dropDownSringItem) {
              return DropdownMenuItem<String>(
                value: dropDownSringItem,
                child: Text(dropDownSringItem),
              );
            }).toList(),
            onChanged: (String newValueSelected) {
              //Code to execute, when a menu item selected
              setState(() {
                this._currentItemSelectedType = newValueSelected;
              });
            },
            style: new TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            value: _currentItemSelectedType,
          ),
          DropdownButton<String>(
            isExpanded: true,
            hint: Text('Продолжительность заявки'),
            items: _actualTime.map((String dropDownSringItem1) {
              return DropdownMenuItem<String>(
                value: dropDownSringItem1,
                child: Text(dropDownSringItem1),
              );
            }).toList(),
            onChanged: (String newValueSelected1) {
              //Code to execute, when a menu item selected
              setState(() {
                this._currentItemSelectedTime = newValueSelected1;
              });
            },
            style: new TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            value: _currentItemSelectedTime,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Комментарий',
            ),
            controller: myController,
          ),
          RaisedButton(
            onPressed: () async {
              if (_currentItemSelectedType != null &&
                  _currentItemSelectedTime != null &&
                  myController.text != null) {
                var user = await fireBloc.getCurrentUser();
                var name;
                if (user.displayName == "") {
                  name = "Вова";
                } else {
                  name = user.displayName;
                }

                fireBloc.createGame({
                  'type': _type.indexOf(_currentItemSelectedType),
                  'author': {'name': name, 'id': user.uid},
                  'actualTime': _currentItemSelectedTime,
                  'comment': myController.text,
                });
              }
            },
            child: Text('Создать'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Назад'),
          ),
        ],
      )),
    );
  }
}
