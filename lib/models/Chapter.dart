import 'dart:convert';
import 'package:http/http.dart';

class ChapterBody {
  final String nextChapter;
  final String prevChapter;
  final String content;

  ChapterBody({this.nextChapter, this.prevChapter, this.content});

  factory ChapterBody.fromJson(Map<String, dynamic> json) {
    return ChapterBody(
      nextChapter: json['nextChapter'] as String,
      prevChapter: json['prevChapter'] as String,
      content: json['content'] as String,
    );
  }

  static ChapterBody fromResponse(Response response) {
    final parsed = jsonDecode(response.body);

    return ChapterBody.fromJson(parsed);
  }
  
}
