import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:wuxia_crowler/service/BoxNovel.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  SearchBar searchBar;

  ListView wuxiaNovels;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Wuxia Novels'),
        actions: [searchBar.getSearchAction(context)]
    );
  }

  _MyHomePageState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: (str) => searchWuxia(this.context, str),
        buildDefaultAppBar: buildAppBar
    );

    wuxiaNovels = new ListView();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: searchBar.build(context),
        body: new Container(
            child: wuxiaNovels
        )
    );
  }

  searchWuxia(BuildContext context, String searchValue) async {

   var list = await BoxNovel.searchNovels(context, searchValue);

    setState(() {
      wuxiaNovels = list;
    });

  }

}