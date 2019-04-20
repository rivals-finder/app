import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List news = [];

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  launchURL(String url) {
    if(url!="")
      launch(url);
    else
      launch('https://google.com');
  }

  Future fetchPost() async {
    final response =
    await http.get('https://perfect-rivals-finder.herokuapp.com/mock');

    if (response.statusCode == 200) {
      print(List.from(json.decode(response.body)['items']));
      setState(() {
        news = List.from(json.decode(response.body)['items']);
      });
      return (json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return news.length == 0 ? CircularProgressIndicator() : _buildContent();
  }

  Widget _buildContent(){
    return ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, position){
          return ListTile(
            title: Text(news[position]['title']),
            subtitle: Text(news[position]['text'], style:TextStyle(fontSize: 12.0)),
            trailing: Text(news[position]['date'], style:TextStyle(color:Colors.grey, fontSize: 10.0)),
              onTap: () { launchURL(news[position]['link']); }
          );
        }
    );
  }

}