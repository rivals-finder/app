import 'package:flutter/material.dart';
import './bloc/bloc.dart';
import './suggestions.dart';
import './news.dart';
import './create.dart';
import './settings.dart';

class Home extends StatefulWidget {
  Home({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

class CustomPopupMenu {
  CustomPopupMenu({this.title});

  String title;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Все'),
  CustomPopupMenu(title: 'Теннис'),
  CustomPopupMenu(title: 'Бильярд'),
  CustomPopupMenu(title: 'Кикер'),
  CustomPopupMenu(title: 'Дартс'),
];

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  FireBloc fireBloc;
  CustomPopupMenu _selectedChoices = choices[0];

  final List<Widget> _children = [
    Suggestions(),
    News(),
  ];

  void initState() {
    super.initState();
    fireBloc = BlocProvider.of(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rivals Finder'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
          PopupMenuButton<CustomPopupMenu>(
            initialValue: choices[choices.indexOf(_selectedChoices)],
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(child: _children[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.timer), title: Text('Предложения')),
          BottomNavigationBarItem(
              icon: Icon(Icons.new_releases), title: Text('Новости')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Creator()),
                );
              },
              tooltip: 'Add',
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
