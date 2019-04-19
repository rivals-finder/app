import 'package:flutter/material.dart';
import './bloc/bloc.dart';
import './Icons/rivals_finder_icons.dart';

class Suggestions extends StatefulWidget {
  Suggestions({Key key}) : super(key: key);

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
        stream: fireBloc.getSuggestionsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              (snapshot.hasData && snapshot.data.snapshot.value == null)) {
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
          RivalsFinderIcons.billiard,
          color: Colors.black,
        );
        break;
      case 1:
        return Icon(
          RivalsFinderIcons.darts,
          color: Colors.black,
        );
        break;
      case 2:
        return Icon(
          RivalsFinderIcons.kicker,
          color: Colors.black,
        );
        break;
      case 3:
        return Icon(
          RivalsFinderIcons.ping_pong,
          color: Colors.black,
        );
        break;
    }
  }

  Widget _buildContent(data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, position) {
        return Dismissible(
          key: Key(data[position]['id']),
          direction: _changeDirection(data[position]['author']['id']),
          confirmDismiss: (DismissDirection direction) async {
            return false;
          },
          onDismissed: (direction) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("${data[position]['comment']} dismissed")));
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
            title: Text(data[position]['comment']),
            subtitle: Text('${data[position]['author']['name']}'),
            trailing: Text('${data[position]['actualTime']}'),
            onTap: null,
          ),
        );
      },
    );
  }
}
