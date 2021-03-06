import 'package:flutter/material.dart';
import './bloc/bloc.dart';
import './Icons/rivals_finder_icons.dart';
import 'package:intl/intl.dart';

class Suggestions extends StatefulWidget {
  Suggestions({Key key, this.filter}) : super(key: key);

  final filter;

  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  FireBloc fireBloc;
  FirebaseUser user;

  void initState() {
    super.initState();
    fireBloc = BlocProvider.of(context);
    getCurrent();
  }

  getCurrent() async {
    user = await fireBloc.getCurrentUser();
    setState(() {
      user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: fireBloc.getSuggestionsStream(widget.filter),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data.snapshot.value == null) {
              return Center(
                child: Text("Активные предложения не найдены, создайте своё"),
              );
            } else {
              List data = [];
              Map _map;
              _map = snapshot.data.snapshot.value;
              _map.forEach((key, value) {
                value.putIfAbsent('id', () => key);
                data.add(value);
              });
              data.sort((c, n) => c['time'] - n['time']);
              return _buildContent(data);
            }
          }
        },
      ),
    );
  }

  DismissDirection _changeDirection(id) {
    bool mine = id == user.uid;
    if (mine) {
      return DismissDirection.endToStart;
    } else {
      return DismissDirection.startToEnd;
    }
  }

  _getIconFromId(id) {
    switch (id) {
      case 0:
        return Icon(
          RivalsFinderIcons.ping_pong,
          color: Colors.black,
          size: 40,
        );
        break;
      case 1:
        return Icon(
          RivalsFinderIcons.billiard,
          color: Colors.black,
          size: 40,
        );
        break;
      case 2:
        return Icon(
          RivalsFinderIcons.kicker,
          color: Colors.black,
          size: 40,
        );
        break;
      case 3:
        return Icon(
          RivalsFinderIcons.darts,
          color: Colors.black,
          size: 40,
        );
        break;
      default:
        return null;
        break;
    }
  }

  Widget _buildContent(data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, position) {
        bool withoutComment = data[position]['comment'] == "";
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(data[position]['actualTime']);
        bool notToday = date.day > DateTime.now().day;
        var formatter = new DateFormat('Hm');
        var formatterDate = new DateFormat('d/MM');
        String formatted = 'до ' + formatter.format(date);
        String formattedDate = 'до ' + formatterDate.format(date);
        return Dismissible(
          key: Key(data[position]['id']),
          direction: _changeDirection(data[position]['author']['id']),
          confirmDismiss: (DismissDirection direction) async {
            if (data[position]['author']['id'] != user.uid) {
              fireBloc.createNotice(data[position]['author']['id'], {
                'idGame': data[position]['id'],
                'type': 2, // answer
                'author': {
                  'name': user.displayName ?? user.email,
                  'id': user.uid
                },
                'date': DateTime.now().millisecondsSinceEpoch,
                'game': data[position],
                'time': 0 - DateTime.now().millisecondsSinceEpoch,
              });
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Предложение \"${data[position]['comment']}\" принято")));
              return false;
            } else {
              return true;
            }
          },
          onDismissed: (direction) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Предложение \"${data[position]['comment']}\" удалено")));
            fireBloc.deleteSuggestion(data[position]['id']);
          },
          background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
              color: Colors.green),
          secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              color: Colors.red),
          child: ListTile(
            leading: _getIconFromId(data[position]['type']),
            title: Text(
              withoutComment
                  ? 'Комментарий остутствует'
                  : data[position]['comment'],
              style: withoutComment
                  ? TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)
                  : null,
            ),
            subtitle: Text('${data[position]['author']['name']}'),
            trailing: Text(notToday ? formattedDate : formatted),
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(data[position]['author']['id'] == user.uid
                          ? 'Вы хотите удалить предложение?'
                          : 'Вы хотите принять предложение?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Закрыть'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(data[position]['author']['id'] == user.uid
                              ? 'Удалить'
                              : 'Принять'),
                          onPressed: () {
                            if (data[position]['author']['id'] == user.uid) {
                              fireBloc.deleteSuggestion(data[position]['id']);
                              Navigator.of(context).pop();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Предложение \"${data[position]['comment']}\" удалено")));
                            } else {
                              fireBloc.createNotice(
                                  data[position]['author']['id'], {
                                'idGame': data[position]['id'],
                                'type': 2, // answer
                                'author': {
                                  'name': user.displayName ?? user.email,
                                  'id': user.uid
                                },
                                'date': DateTime.now().millisecondsSinceEpoch,
                                'game': data[position],
                                'time':
                                    0 - DateTime.now().millisecondsSinceEpoch,
                              });
                              Navigator.of(context).pop();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Предложение \"${data[position]['comment']}\" принято")));
                            }
                          }, // onPressed
                        ),
                      ],
                    );
                  });
            },
          ),
        );
      },
    );
  }
}
