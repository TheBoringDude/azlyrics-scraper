class Song {
  final String _singer;
  // final String _author;
  final String _lyrics;
  final String _title;

  Song(String singer, String title, String lyrics)
      : _singer = singer,
        _title = title,
        _lyrics = lyrics;
  // _author = author,

  String get singer {
    return _singer;
  }

  // String get author {
  //   return _author;
  // }

  String get lyrics {
    return _lyrics;
  }

  String get title {
    return _title;
  }
}
