import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sprintf/sprintf.dart';

import 'package:wyly/src/handlers/req.dart';

enum QueryTypes { songs, lyrics }

const AzLyricsSearch_Lyrics = 'https://search.azlyrics.com/search.php?q=%s&w=lyrics&p=1';
const AzLyricsSearch_Songs = 'https://search.azlyrics.com/search.php?q=%s&w=songs&p=1';

class AzLyrics {
  List<Map<String, String>> qLyrics = [];

  static Future<Document> query(QueryTypes t, String q) async {
    var w = '';

    switch (t) {
      case QueryTypes.lyrics:
        w = AzLyricsSearch_Lyrics;
        break;
      case QueryTypes.songs:
        w = AzLyricsSearch_Songs;
        break;
      default:
        print('unknown query type');
        exit(1);
    }

    final r = await requester(sprintf(AzLyricsSearch_Songs, [q]));
    return parse(r);
  }

  Future<List<Map<String, String>>> search_songs(String query) async {
    var qSongs = <Map<String, String>>[];

    final doc = await AzLyrics.query(QueryTypes.songs, query);

    for (var i in doc.getElementsByClassName('visitedlyr')) {
      var song = {
        'title': i.querySelector('a').text.trim(),
        'author': i.querySelectorAll('b')[1]?.text?.trim(),
        'link': i.querySelector('a').attributes['href'].trim(),
      };

      qSongs.add(song);
    }

    return qSongs;
  }
}
