import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wuxia_crowler/pages/ChaptersPage.dart';

class Chapter {
  final String title;
  final String link;

  Chapter({this.title, this.link});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
        title: json['title'] as String, link: json['link'] as String);
  }
}

class NovelDetail {
  final String title;
  final String img;

  final String description;

  NovelDetail({this.title, this.img, this.description});

  factory NovelDetail.fromJson(Map<String, dynamic> json) {
    return NovelDetail(
      title: json['title'] as String,
      img: json['img'] as String,
      description: json['description'] as String,
    );
  }
}

class NovelDetailResponse {
  final NovelDetail data;
  final List<Chapter> chapters;

  NovelDetailResponse({this.data, this.chapters});

  static NovelDetailResponse fromResponse(Response response) {
    final parsedData = jsonDecode(response.body)['data'];
    final parsedChapters = jsonDecode(response.body)['chapter'];

    final data = NovelDetail.fromJson(parsedData);

    List<Chapter> chapters =
        parsedChapters.map<Chapter>((json) => Chapter.fromJson(json)).toList();

    return NovelDetailResponse(data: data, chapters: chapters);
  }

  static Container toDetailView(
      BuildContext context, NovelDetailResponse novel) {
    RaisedButton listChapters = RaisedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new ChaptersPage(
                    novel: novel.data, chapters: novel.chapters)));
      },
      child: const Text('Chapters', style: TextStyle(fontSize: 20)),
      padding: const EdgeInsets.all(10.0),
    );

    List<Widget> details = [
      Image.network(novel.data.img),
      Text(
        novel.data.description,
        softWrap: true,
      ),
      Center(
        child: Row(
          children: [
            listChapters,
          ],
        ),
      )
    ];

    return new Container(
        child: Column(
      children: details,
    ));
  }
}
