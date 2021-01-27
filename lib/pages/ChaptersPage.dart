import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wuxia_crowler/models/NovelDetail.dart';

import 'ChapterPage.dart';

class ChaptersPage extends StatefulWidget {
  ChaptersPage({Key key, this.novel, this.chapters}) : super(key: key);

  final NovelDetail novel;
  final List<Chapter> chapters;

  @override
  _ChaptersPageState createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  bool invert = false;

  SizedBox chaptersList() {
    List<Chapter> ordered = invert ? widget.chapters.reversed.toList() : widget.chapters;

    return new SizedBox(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: ordered.length,
            itemBuilder: (BuildContext cxt, int index) {
              return new ListTile(
                title: Text(ordered[index].title),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => new ChapterPage(
                      novel: widget.novel, chapter: ordered[index])));
                },
              );
            },
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(title: new Text(widget.novel.title), actions: [
      IconButton(
        icon: Icon(invert ? Icons.arrow_drop_up : Icons.arrow_drop_down),
        tooltip: 'Order',
        onPressed: () {
          setState(() {
            invert = !invert;
          });
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: buildAppBar(context), body: chaptersList());
  }
}
