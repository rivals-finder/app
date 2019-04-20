import 'package:flutter/material.dart';
import './bloc/bloc.dart';

class Notice extends StatefulWidget {
  Notice({Key key}) : super(key: key);

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  FireBloc fireBloc;

  void initState() {
    super.initState();
    fireBloc = BlocProvider.of(context);
    getList();
  }

  getList() async {
    var q = await fireBloc.getTestList();
    print(q);
  }

  final List<Map> _items = [
    {
      'id': 1,
      'name': 'Petr',
      'type': 0,
      'text': 'Tralalala',
      'date': '02.02.2017',
    },
    {
      'id': 2,
      'name': 'Anna',
      'type': 0,
      'text': 'asfafa',
      'date': '20.04.2017',
    },
    {
      'id': 3,
      'name': 'Dasha',
      'type': 0,
      'text': 'hjl',
      'date': '07.12.2017',
    },
    {
      'id': 4,
      'name': 'Vlad',
      'type': 0,
      'text': 'iopui',
      'date': '04.01.2018',
    },
    {
      'id': 5,
      'name': 'Maks',
      'type': 0,
      'text': 'zxgxfdf',
      'date': '13.02.2018',
    },
    {
      'id': 6,
      'name': 'Sasha',
      'type': 0,
      'text': 'qgfdb',
      'date': '18.06.2018',
    }
  ];

  createNotice(uid, map) async {
    UserInfo user = await fireBloc.getCurrentUser();
    fireBloc.createNotice(uid, {
      'idGame': 'id',
      'type': 0,
      'author': {'name': user.displayName ?? user.email, 'id': user.uid},
      'date': DateTime.now().millisecondsSinceEpoch,
      'game': {
        'type': 1,
        'author': {'name': 'test', 'id': 'id'},
        'actualTime': DateTime.now().millisecondsSinceEpoch,
        'comment': 'Go igrat',
        'time': 0 - DateTime.now().millisecondsSinceEpoch
      },
      'time': 0 - DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text('Notice'), centerTitle: true),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, key) {
          return Dismissible(
            key: Key(_items[key]['name']),
            onDismissed: (direction) {
              createNotice('5', {});
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("${_items[key]['text']} dismissed")));
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
              leading: Icon(Icons.phone),
              title: Text(_items[key]['text']),
              subtitle: Text(_items[key]['name']),
              trailing: Text(_items[key]['date']),
            ),
          );
        },
      ),
    ));
  }
}
