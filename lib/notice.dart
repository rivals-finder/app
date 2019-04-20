import 'package:flutter/material.dart';
import './bloc/bloc.dart';

class Notice extends StatefulWidget {
  Notice({Key key}) : super(key: key);

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  FireBloc fireBloc;
  FirebaseUser user;

  void initState() {
    super.initState();
    fireBloc = BlocProvider.of(context);
    getList();
    getCurrent();
  }

  getList() async {
    var q = await fireBloc.getTestList();
    print(q);
  }

  createNotice(uid, map) async {
    UserInfo user = await fireBloc.getCurrentUser();
    fireBloc.createNotice(uid, {
      'idGame': 'id',
      'type': 0,
      'author': {'name': user.displayName ?? user.email, 'id': user.uid},
      'date': DateTime
          .now()
          .millisecondsSinceEpoch,
      'game': {
        'type': 1,
        'author': {'name': 'test', 'id': 'id'},
        'actualTime': DateTime
            .now()
            .millisecondsSinceEpoch,
        'comment': 'Go igrat',
        'time': 0 - DateTime
            .now()
            .millisecondsSinceEpoch
      },
      'time': 0 - DateTime
          .now()
          .millisecondsSinceEpoch,
    });
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
      appBar: AppBar(title: Text('Notice'), centerTitle: true),
      body: user != null
          ? StreamBuilder(
              stream: fireBloc.getNoticeStream(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    (snapshot.hasData &&
                        snapshot.data.snapshot.value == null)) {
                  return Center( child: Text('Уведомлений нет') );
                } else {
                  List data = [];
                  Map _map;
                  _map = snapshot.data.snapshot.value;
                  _map.forEach((key, value) {
                    value.putIfAbsent('id', () => key);
                    data.add(value);
                  });
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, key) {
                      switch(data[key]['type']) {
                        case 1:
                          return _allowDismissible(data[key]);
                        break;
                        case 2:
                          return _answerDismissible(data[key]);
                        break;
                        case 3:
                          return _declineDismissible(data[key]);
                        break;
                        default:
                          return null;
                      }
                    },
                  );
                }
              },
            )
          : CircularProgressIndicator(),
    );
  }

  Dismissible _answerDismissible(data) {
    return Dismissible(
      key: Key(data['id']),
      onDismissed: (direction) {
        int type = direction == DismissDirection.startToEnd ? 1 : 3;
        fireBloc.createNotice(data['author']['id'], {
          'idGame': data['game']['id'],
          'type': type,
          'author': {'name': user.displayName ?? user.email, 'id': user.uid},
          'date': DateTime.now().millisecondsSinceEpoch,
          'game': data['game'],
          'time': 0 - DateTime.now().millisecondsSinceEpoch,
        });
        fireBloc.deleteNotice(user.uid, data['id']);
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
        leading: Icon(Icons.help),
        title: Text(data['author']['name']),
        subtitle: Text('Откликнулся на \'${data['game']['comment']}\''),
        trailing: Text(data['date'].toString()),
      ),
    );
  }

  Dismissible _declineDismissible(data) {
    return Dismissible(
      key: Key(data['id']),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        fireBloc.deleteNotice(user.uid, data['id']);
      },
      background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          color: Colors.red),
      child: ListTile(
        leading: Icon(Icons.phone),
        title: Text(data['author']['name']),
        subtitle: Text('Отклонил игру \'${data['game']['type']}\''),
      ),
    );
  }


  Dismissible _allowDismissible(data) {
    return Dismissible(
      key: Key(data['id']),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        fireBloc.deleteNotice(user.uid, data['id']);
      },
      background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          color: Colors.red),
      child: ListTile(
        leading: Icon(Icons.phone),
        title: Text(data['author']['name']),
        subtitle: Text('Подтвердил игру в \'${data['game']['type']}\''),
      ),
    );
  }

}
