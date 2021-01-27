import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wuxia_crowler/models/Chapter.dart';
import 'package:wuxia_crowler/models/NovelDetail.dart';

class NovelApi {
  static Future<Container> getNovel(BuildContext context, String title) async {

    final String formattedTitle =
    title
        .toLowerCase()
        .replaceAll(new RegExp(r'[^\w\s]+'),'')
        .replaceAll(" ", "-");

    final String uri = 'https://kooma-api.herokuapp.com/boxnovel/novels?title=' + formattedTitle;

    var response = await http.get(uri);

    var novels = NovelDetailResponse.fromResponse(response);

    return NovelDetailResponse.toDetailView(context, novels);
  }

  static Future<ChapterBody> getChapterDetails(Chapter chapter) async {
    var response = await http.get(chapter.link);

    return ChapterBody.fromResponse(response);
  }
}
