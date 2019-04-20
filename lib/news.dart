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
    if (url != "") launch(url);
  }

  Future fetchPost() async {
    final response =
        await http.get('https://perfect-rivals-finder.herokuapp.com/news/20');

    if (response.statusCode == 200) {
      setState(() {
        news = List.from(json.decode(response.body)['items']);
      });
      return (json.decode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return news.length == 0 ? CircularProgressIndicator() : _buildContent();
  }

  Widget _buildContent() {
    return ListView.separated(
        itemCount: news.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (context, position) {
          var listTile = ListTile(
              title: Text(news[position]['title']),
              subtitle: Text(news[position]['text'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.0)),
              onTap: () {
                launchURL(news[position]['link']);
              });
          return listTile;
        });
  }
}
