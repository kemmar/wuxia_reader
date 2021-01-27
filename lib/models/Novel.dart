import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/scroll_view.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:wuxia_crowler/pages/NovelPage.dart';

class Novel {
  final String url;
  final String title;

  Novel({this.url, this.title});

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      url: json['url'] as String,
      title: json['title'] as String,
    );
  }

  static List<Novel> fromResponse(Response response) {
    final parsed = jsonDecode(response.body)['data'];

    return parsed.map<Novel>((json) => Novel.fromJson(json)).toList();
  }

  static ListView toListView(BuildContext context, List<Novel> novels) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children: novels
            .map((novel) => new ListTile(
                  title: Text(novel.title),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new NovelPage(novel: novel)));
                  },
                ))
            .toList(growable: false));
  }
}
