import 'package:flutter/material.dart';
import './bloc/bloc.dart';
import './Icons/rivals_finder_icons.dart';

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              sendDataMethod();
            },
          )
        ],
      ),
      body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
              children: <Widget>[
                Container(
                  child: ButtonTheme(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Выбрать игру'),
                      items: _type.map((String dropDownSringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownSringItem,
                          child: Container(
                              child: Row(
                            children: <Widget>[
                              _getIconFromName(dropDownSringItem),
                              Container(
                                width: 20.0,
                              ),
                              Text(dropDownSringItem),
                            ],
                          )),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        setState(() {
                          this._currentItemSelectedType = newValueSelected;
                        });
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      value: _currentItemSelectedType,
                    ),
                  ),
                ),
                //----------------------
                DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Продолжительность заявки'),
                  items: _actualTime.map((String dropDownSringItem1) {
                    return DropdownMenuItem<String>(
                      value: dropDownSringItem1,
                      child: Row(
                        children: <Widget>[
                          Text(dropDownSringItem1),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String newValueSelected1) {
                    setState(() {
                      this._currentItemSelectedTime = newValueSelected1;
                    });
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                  value: _currentItemSelectedTime,
                ),

                TextField(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Комментарий',
                  ),
                  controller: myController,
                ),
              ],
              //-----------------------------------------------------
            )),
      ),
    );
  }

  Icon _getIconFromName(name) {
    switch (name) {
      case 'Теннис':
        return Icon(RivalsFinderIcons.ping_pong);
        break;
      case 'Бильярд':
        return Icon(RivalsFinderIcons.billiard);
        break;
      case 'Кикер':
        return Icon(RivalsFinderIcons.kicker);
        break;
      case 'Дартс':
        return Icon(RivalsFinderIcons.darts);
        break;
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Ошибка"),
      content: Text("Не все поля заполнены."),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  sendDataMethod() async {
    if (_currentItemSelectedType != null &&
        _currentItemSelectedTime != null &&
        myController.text != null) {
      UserInfo user = await fireBloc.getCurrentUser();
      fireBloc.createGame({
        'type': _type.indexOf(_currentItemSelectedType),
        'author': {'name': user.displayName ?? user.email, 'id': user.uid},
        'actualTime': _getDateFromSelectedName(_currentItemSelectedTime),
        'comment': myController.text,
        'time': 0 - DateTime.now().millisecondsSinceEpoch
      });
      Navigator.pop(context);
    } else {
      showAlertDialog(context);
    }
  }

  int _getDateFromSelectedName(name) {
    switch (name) {
      case '1 час':
        return DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch,
                isUtc: true)
            .add(Duration(hours: 1))
            .toUtc()
            .millisecondsSinceEpoch;
        break;
      case '2 часа':
        return DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch,
                isUtc: true)
            .add(Duration(hours: 2))
            .toUtc()
            .millisecondsSinceEpoch;
        break;
      case '1 день':
        return DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch,
                isUtc: true)
            .add(Duration(days: 1))
            .toUtc()
            .millisecondsSinceEpoch;
        break;
      case '1 неделя':
        return DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch,
                isUtc: true)
            .add(Duration(days: 7))
            .toUtc()
            .millisecondsSinceEpoch;
        break;
    }
  }
}
