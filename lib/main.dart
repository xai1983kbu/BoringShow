import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'src/article.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _ids = [
    19756125,
    19758126,
    19763413,
    19768072,
    19774019,
    19774997,
    19757013,
    19768012,
  ];

  Future<Article> _getArticle(int id) async {

    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
  }

  //List<Article> _articles = articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _ids.map((i) =>
          FutureBuilder<Article>(
            future: _getArticle(i),
            builder: (BuildContext context, AsyncSnapshot<Article> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildItem(snapshot.data);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ).toList(),
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.title),
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(
          article.title,
          style: TextStyle(fontSize: 28.0),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(article.type),
              IconButton(
                  icon: Icon(Icons.launch),
                  onPressed: () async {
                    if (await canLaunch(article.url)) {
                      launch(article.url);
                    }
                  })
            ],
          ),
        ],
      ),
    );
  }
}
