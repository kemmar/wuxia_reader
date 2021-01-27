import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quiver/iterables.dart';
import 'package:wuxia_crowler/models/Chapter.dart';
import 'package:wuxia_crowler/models/Novel.dart';
import 'package:wuxia_crowler/models/NovelDetail.dart';
import 'package:wuxia_crowler/pages/NovelPage.dart';
import 'package:wuxia_crowler/service/NovelApi.dart';

class ChapterPage extends StatefulWidget {
  ChapterPage({Key key, this.novel, this.chapter}) : super(key: key);

  final NovelDetail novel;
  final Chapter chapter;

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  ChapterBody chapterBody =
      new ChapterBody(nextChapter: "", prevChapter: "", content: "");

  PageController _pageController = PageController();
  FlutterTts flutterTts;
  List<String> paragraphs = List.empty();
  List<Container> lines = List.empty();

  bool _playing;

  void initState() {
    super.initState();

    flutterTts = FlutterTts();

    flutterTts.setCompletionHandler(() {
      playNext();
    });

    _playing = false;

    flutterTts.stop();

    WidgetsBinding.instance.addPostFrameCallback((_) => getChapterBody());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  getChapterBody() async {
    var body = chapterBody = await NovelApi.getChapterDetails(widget.chapter);

    List<String> para = partition(body.content.split("\n"), 10)
        .map((e) => e.reduce((value, element) => value + "\n\n" + element))
        .toList();

    setState(() {
      chapterBody = body;
      paragraphs = para;
      lines = para
          .map((e) => new Container(
                  child: Text(
                e,
                style: TextStyle(fontSize: 15),
              )))
          .toList();
    });
  }

  playNext() {
    var page = _pageController.page.toInt();
    var pages = paragraphs.length - 1;

    if (page < pages) {
      _pageController
          .nextPage(
              duration: Duration(milliseconds: 250), curve: Curves.easeInOut)
          .whenComplete(() => playAudio());
    } else {
      stopAudio();
    }
  }

  playAudio() async {
    await flutterTts.speak(paragraphs[_pageController.page.toInt()]);

    setState(() {
      _playing = true;
    });
  }

  stopAudio() async {
    await flutterTts.stop();

    setState(() {
      _playing = false;
    });
  }

  AppBar buildAppBar() {
    return new AppBar(
        title: new Text(
          widget.chapter.title,
          overflow: TextOverflow.visible,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (_pageController.hasClients) {
                _pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
                stopAudio();
              } else {}
            },
          ),
          IconButton(
            icon: Icon(_playing ? Icons.stop : Icons.headset),
            tooltip: 'Listen',
            onPressed: () {
              if (_playing) {
                stopAudio();
              } else {
                playAudio();
              }
            },
          ),
          IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                if (_pageController.hasClients) {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                  stopAudio();
                } else {}
              }),
        ]);
  }

  BottomAppBar buildBottomAppBar() {
    prevChapter() {
      Chapter prevChapter = new Chapter(
          title: widget.chapter.title, link: chapterBody.prevChapter);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
              new ChapterPage(novel: widget.novel, chapter: prevChapter)));
    }

    nextChapter() {
      Chapter nextChapter = new Chapter(
          title: widget.chapter.title, link: chapterBody.nextChapter);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  new ChapterPage(novel: widget.novel, chapter: nextChapter)));
    }

    home() {
      Novel mainNovel = new Novel(
          url: widget.chapter.link, title: widget.novel.title); // invalid link

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new NovelPage(novel: mainNovel)));
    }

    return new BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new IconButton(
              icon: Icon(Icons.arrow_back_sharp), onPressed: prevChapter),
          new IconButton(icon: Icon(Icons.home_outlined), onPressed: home),
          new IconButton(
              icon: Icon(Icons.arrow_forward_sharp), onPressed: nextChapter),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(),
        body: Container(
          child: Center(
            child: PageView(
              controller: _pageController,
              children: lines,
            ),
          ),
          padding: EdgeInsets.all(15),
        ),
        bottomNavigationBar: buildBottomAppBar(),
      ),
    );
  }
}
