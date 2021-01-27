import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/scroll_view.dart';
import 'package:wuxia_crowler/models/Novel.dart';
import 'package:http/http.dart' as http;

class BoxNovel {
  static Future<ListView> searchNovels(BuildContext context, String searchValue) async {
    final uri = 'https://boxnovel.com/wp-admin/admin-ajax.php';
    var map = new Map<String, dynamic>();

    map['action'] = 'wp-manga-search-manga';
    map['title'] = searchValue;

    var response = await http.post(uri, body: map);

    var novels = Novel.fromResponse(response);

    return Novel.toListView(context, novels);
  }
}
