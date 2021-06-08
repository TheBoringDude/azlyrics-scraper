import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sprintf/sprintf.dart';

import 'package:wyly/src/handlers/req.dart';

enum QueryTypes { songs, lyrics }

const AzLyricsSearch_Lyrics = 'https://search.azlyrics.com/search.php?q=%s&w=lyrics&p=1';
const AzLyricsSearch_Songs = 'https://search.azlyrics.com/search.php?q=%s&w=songs&p=1';

class AzLyrics {
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

    final r = await requester(sprintf(w, [q]));
    return parse(r);
  }

  Map<String, String> _parse_td(Element i) {
    return {
      'title': i.querySelector('a').text.trim(),
      'author': i.querySelectorAll('b')[1]?.text?.trim(),
      'link': i.querySelector('a').attributes['href'].trim(),
    };
  }

  Future<List<Map<String, String>>> search_lyrics(String query) async {
    var qLyrics = <Map<String, String>>[];

    final doc = await AzLyrics.query(QueryTypes.lyrics, query);

    for (var i in doc.getElementsByClassName('visitedlyr')) {
      var song = _parse_td(i);
      song['lyrics'] = i.querySelector('small').text.trim();

      qLyrics.add(song);
    }

    return qLyrics;
  }

  Future<List<Map<String, String>>> search_songs(String query) async {
    var qSongs = <Map<String, String>>[];

    final doc = await AzLyrics.query(QueryTypes.songs, query);

    for (var i in doc.getElementsByClassName('visitedlyr')) {
      var song = _parse_td(i);

      qSongs.add(song);
    }

    return qSongs;
  }
}
