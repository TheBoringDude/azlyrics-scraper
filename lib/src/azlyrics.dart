import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sprintf/sprintf.dart';
import 'package:wyly/src/handlers/song.dart';

import 'package:wyly/src/handlers/req.dart';

enum QueryTypes {
  songs,
  lyrics,
  page,
}

const AzLyricsSearch_Lyrics = 'https://search.azlyrics.com/search.php?q=%s&w=lyrics&p=1';
const AzLyricsSearch_Songs = 'https://search.azlyrics.com/search.php?q=%s&w=songs&p=1';

class AzLyrics extends Song {
  AzLyrics.__init(String singer, String lyrics, String title) : super(singer, lyrics, title);

  /// init is a static initializer for the class to better handle async futures
  static Future<AzLyrics> init(String uri) async {
    if (!uri.startsWith('https://www.azlyrics.com/lyrics/')) {
      throw 'Invalid start URI!';
    }

    final doc = await AzLyrics.query(QueryTypes.page, uri);

    final container = doc.querySelector('.col-xs-12.col-lg-8.text-center');

    final singer = container.querySelector('.lyricsh').text.replaceAll('Lyrics', '').trim();
    final title = container.querySelector('b').text.trimLeft();
    final lyrics = container.getElementsByTagName('div')[5]?.text?.trim();

    return AzLyrics.__init(singer, title, lyrics);
  }

  /// default query handler wrapper
  static Future<Document> query(QueryTypes t, String q) async {
    var w = '';

    switch (t) {
      case QueryTypes.lyrics:
        w = AzLyricsSearch_Lyrics;
        break;
      case QueryTypes.songs:
        w = AzLyricsSearch_Songs;
        break;
      case QueryTypes.page:
        w = q;
        break;

      default:
        print('unknown query type');
        exit(1);
    }

    final r = await requester(t == QueryTypes.page ? q : sprintf(w, [q]));
    return parse(r);
  }

  /// a helper for parsing search results
  static Map<String, String> parse_result_td(Element i) {
    return {
      'title': i.querySelector('a').text.trim(),
      'author': i.querySelectorAll('b')[1]?.text?.trim(),
      'link': i.querySelector('a').attributes['href'].trim(),
    };
  }

  /// search_lyrics searches for the query in the lyrics
  static Future<List<Map<String, String>>> search_lyrics(String query) async {
    var qLyrics = <Map<String, String>>[];

    final doc = await AzLyrics.query(QueryTypes.lyrics, query);

    for (var i in doc.getElementsByClassName('visitedlyr')) {
      var song = AzLyrics.parse_result_td(i);
      song['lyrics'] = i.querySelector('small').text.trim();

      qLyrics.add(song);
    }

    return qLyrics;
  }

  /// search_songs searches for the query in the song titles
  static Future<List<Map<String, String>>> search_songs(String query) async {
    var qSongs = <Map<String, String>>[];

    final doc = await AzLyrics.query(QueryTypes.songs, query);

    for (var i in doc.getElementsByClassName('visitedlyr')) {
      var song = AzLyrics.parse_result_td(i);

      qSongs.add(song);
    }

    return qSongs;
  }
}
