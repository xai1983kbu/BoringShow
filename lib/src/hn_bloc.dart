import 'dart:collection';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:hnews/src/article.dart';

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();
  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  var _articles = <Article>[];


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

  HackerNewsBloc() {
    _updateArticles().then((_) {
      _articlesSubject.add(UnmodifiableListView(_articles));
    });
  }

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
  }

  Future<Null> _updateArticles() async {
    final futureArticles = _ids.map((id) => _getArticle(id));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}