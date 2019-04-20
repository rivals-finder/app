import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './bloc/bloc.dart';

class Chat extends StatefulWidget {
  Chat({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  FireBloc fireBloc;
  FirebaseUser user;
  final ScrollController listScrollController = new ScrollController();

  final myController = TextEditingController();
  String text;

  void initState() {
    super.initState();
    text = '';
    fireBloc = BlocProvider.of(context);
    myController.addListener(() {
      setState(() {
        text = myController.text;
      });
    });
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
      body: Column(
        children: <Widget>[
          new Expanded(
            // flex: 1,
            child: StreamBuilder(
              stream: fireBloc.getChatStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    (snapshot.hasData &&
                        snapshot.data.snapshot.value == null)) {
                  return Center(child: Text("Чат пуст. Будьте первым!"));
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
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Комментарий',
                  ),
                  controller: myController,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: text != "" ? sendMessage : null)
            ],
          ),
        ],
      ),
    );
  }

  sendMessage() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('Hm');
    String formatted = formatter.format(now);
    var user = await fireBloc.getCurrentUser();
    fireBloc.sendMessage({
      'author': {'name': user.displayName ?? user.email, 'id': user.uid},
      'date': formatted,
      'message': myController.text,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    myController.clear();
  }

  Widget forScroll(data, key) {
    bool mine = data[key]['author']['id'] == user.uid;
    if (mine) {
      return Dismissible(
        key: Key(data[key]['id']),
        direction: DismissDirection.endToStart,
        confirmDismiss: (DismissDirection direction) async {
          if (data[key]['author']['id'] != user.uid) {
            return false;
          } else {
            return true;
          }
        },
        onDismissed: (direction) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("message deleted")));
          fireBloc.deleteMessageChat(data[key]['id']);
        },
        background: Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            color: Colors.white),
        child: _messageModifier(data, key),
      );
    } else {
      return Container(
        child: _messageModifier( data, key),
      );
    }
  }

  Widget _buildContent(data) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      controller: listScrollController,
      reverse: true,
      itemCount: data.length,
      itemBuilder: (context, key) {
        return forScroll(data, key);
      },
    );
  }

  Row _messageModifier(data, key) {
    var timeSend = data[key]['date'];
    if (data[key]['author']['id'] == user.uid) {
      return new Row(
        //my message
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                child: Text(data[key]['message']),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 260.0,
                decoration: new BoxDecoration(
                    color: Color(0xFFBAC6DB),
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(bottom: 1.0, right: 10.0, top: 10.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 0.0, top: 5.0, bottom: 5.0),
                child: Text("Я написал в " + timeSend.toString()),
              )
            ],
          )
        ],
      );
    } else {
      return new Row(
        // not my message
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                child: Text(data[key]['message']),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 260.0,
                decoration: new BoxDecoration(
                    color: Color(0xff7c94b6),
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(bottom: 1.0, left: 10.0, top: 10.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 0.0, top: 5.0, bottom: 5.0),
                child: Text(data[key]['author']['name'] +
                    " написал в " +
                    timeSend.toString()),
              )
            ],
          ),
        ],
      );
    }
  }
}
