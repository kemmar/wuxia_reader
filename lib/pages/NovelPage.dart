import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wuxia_crowler/models/Novel.dart';
import 'package:wuxia_crowler/service/NovelApi.dart';

class NovelPage extends StatefulWidget {
  NovelPage({Key key, this.novel}) : super(key: key);

  final Novel novel;

  @override
  _NovelPageState createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {

  Container novelDetails;

  _NovelPageState() {
    novelDetails = new Container();
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getNovelDetails());
  }

  AppBar buildAppBar() {
    return new AppBar(
        title: new Text(widget.novel.title)
    );
  }

  getNovelDetails() async {

    var novelDetail = await NovelApi.getNovel(this.context, widget.novel.title);

    setState(() {
      novelDetails = novelDetail;
    });

  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: buildAppBar(),
      body: novelDetails
    );
  }
}