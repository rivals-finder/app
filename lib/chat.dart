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
          Expanded(
            flex: 1,
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
                  data.sort((c, n) => n['time'] - c['time']);
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
      'time': 0 - DateTime.now().millisecondsSinceEpoch,
    });
    myController.clear();
  }

  DismissDirection _changeDirection(id) {
    bool mine = id == user.uid;
    if (mine) {
      return DismissDirection.endToStart;
    } else {
      return null;
    }
  }

  /*Widget _buildContent(data) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
   //  padding: EdgeInsets.all(10.0),
      itemCount: data.length,
      itemBuilder: (context, key) {
        return Dismissible(
          key: Key(data[key]['id']),
          direction: _changeDirection(data[key]['author']['id']),
          confirmDismiss: (DismissDirection direction) async {
            if (data[key]['author']['id'] != user.uid) {

              return false;
            } else {
              return true;
            }
          },
          onDismissed: (direction) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("message deleted")));
            fireBloc.deleteMessageChat(data[key]['id']);
          },
          background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              color: Colors.red),
              
          child: SizedBox(
            
            width: width/2,
            child: ListTile(
              title: Text(data[key]['author']['name']),
              subtitle: Text(data[key]['message'] ),
              trailing: Text(data[key]['date']),
              onTap: null,
            ),
          ),
        );
      },
    );
  }*/

  Widget _buildContent(data) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      //padding: EdgeInsets.all(10.0),
      itemCount: data.length,
      itemBuilder: (context, key) {
        return Dismissible(
          key: Key(data[key]['id']),
          direction: _changeDirection(data[key]['author']['id']),
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
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              color: Colors.red),
             child:SizedBox(           
            width: width,
            child: ListTile(
              title: Text(data[key]['author']['name']),
              subtitle: Text(data[key]['message'] ),
              trailing: Text(data[key]['date']),
              onTap: null,
            ),
          
          ),
        );
      },
    );
  }
}
