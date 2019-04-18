import 'package:flutter/material.dart';
import './auth.dart';
import './bloc/bloc.dart';

class Home extends StatefulWidget {
  Home({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await fireBloc.logOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Auth()),
              );
            },
          )
        ],
      ),
      body: Center(child: Text('Tensor Hack 2019')),
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
              onPressed: () {},
              tooltip: 'Add',
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
